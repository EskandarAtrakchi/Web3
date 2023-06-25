pragma solidity ^0.8.4;
interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
    function claim() external;
}

interface IPriceFeed {
    function getPriceTokenUSDT(address token) external view returns(uint256);
}
interface IFundFactory {
    function isKYCed(address _add) external view returns(bool);
}

contract AvanzoNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    mapping(uint => uint) tokenIdToUSDT;
    Counters.Counter private _tokenIdCounter;
    address marketPlace;
    address receiver;
    IFundFactory fundFactory;
    uint cap;
    uint tDollar;
    uint tToken;
    bool public depositsClosed = false;
    bool public dead = false; 
    bool public KYC;
    IPriceFeed priceFeed;
    IERC20 token;
    uint[] toMint;
    mapping(address => bool) isHolder;  
    address[] holders;
    constructor(address _marketplace, address _receiver, uint _cap, address _priceFeed, address _token, bool _KYC) ERC721("AvanzoNFT", "AV") {
        marketPlace = _marketplace;
        receiver = _receiver;
        cap = _cap;
        priceFeed = IPriceFeed(_priceFeed);
        token = IERC20(_token);
        _transferOwnership(tx.origin);
        fundFactory = IFundFactory(msg.sender);
        KYC = _KYC;
    }
    event newDeposit(address indexed investor, uint256 indexed amountInTokens, uint256 indexed amountInDollars);
    event newWithdraw(address indexed investor, uint256 indexed amountInTokens, uint256 indexed amountInDollars);
    event kill(uint256 indexed time);
    event distRewards(address indexed rewarder, uint256 indexed amountInTokens, address indexed token);
    event startInvestment(uint256 time);
    event newProposal(string indexed proposal, uint256 id);
    event newVote(address indexed voter, uint256 indexed id, bool indexed choice);
    modifier onlyMarketPlace() {
        require(msg.sender == marketPlace || msg.sender == address(fundFactory));
        _;
    }
    function _baseURI() internal pure override returns (string memory) {
        return "https://lol.json/";
    }
    function _mintNFT(address _to, uint _dollar) private {
        if(toMint.length != 0)  {
            uint CtokenId = toMint.length-1;
            toMint.pop();
            _safeMint(_to, CtokenId);
            tokenIdToUSDT[CtokenId] = _dollar;
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(_to, tokenId);
        tokenIdToUSDT[tokenId] = _dollar;
        _checkHolder(msg.sender);
    }
    function _checkHolder(address _of) private {
        if (balanceOf(_of) > 0  && !isHolder[_of]) {
           holders.push(_of);
           isHolder[_of] = true;
        } else if(balanceOf(_of) == 0 && isHolder[_of]) {
            _remove(_of);
            isHolder[_of] = false;
        }
    }
    function _getValues() private view returns(uint[] memory)  {
        uint[] memory values = new uint[](holders.length);
        for(uint i; i < values.length; i++) {
            uint[] memory nfts = new uint[](balanceOf(holders[i]));
            nfts = getAllNFTsOwnerBy(holders[i]);
            uint _oValue;
            for(uint x; x < nfts.length; i++)  {
                _oValue += tokenIdToUSDT[nfts[i]];
            }
            values[i] = _oValue;
        }
        return values;
    }
    function _remove(address _of) private{
        uint index;
        for(uint i; i < holders.length; i++)  {
            if(holders[i] == _of) {
                index = i;
                break;
            }}
        holders[index] = holders[holders.length - 1];
        holders.pop();
        for(uint i = index; i < holders.length-1; i++){
            holders[i] = holders[i+1];      
        }
        holders.pop();
    }
    function setMarketPlace(address  _marketPlace) public onlyOwner {
        marketPlace = _marketPlace;
    }
    function setFundFactory(address _fundFactory) public onlyOwner {
        fundFactory = IFundFactory(_fundFactory);
    }
    function transferMarketPlace(address _from, uint256 _tokenId, address _to) public onlyMarketPlace returns(bool){
        _transfer(_from, _to, _tokenId);
        _mergeNFT(_to);
        return true;
    }
    function buyNFT(uint _amountInTokens) public {
        if(KYC) {
            require(fundFactory.isKYCed(msg.sender), "requires KYC!");
        }
        uint price = priceFeed.getPriceTokenUSDT(address(token));
        uint _dollar = (price * _amountInTokens) / 1e18;
        require(_dollar >= 500e18, "min. investment equals 500$!");
        _endDeposits();
        require(tDollar + _dollar <= cap + 1e18, "cap reached!");
        require(token.transferFrom(msg.sender, address(this), _amountInTokens));
        tDollar += _dollar;
        tToken += _amountInTokens;
        _mintNFT(msg.sender, _dollar);
        if(balanceOf(msg.sender) > 1)
            _mergeNFT(msg.sender);
        updateBalances();
        emit newDeposit(msg.sender, _amountInTokens, _dollar);
    }
    function mergeNFT() public {
        require(balanceOf(msg.sender) > 1, "You only own 1 NFT!");
        _mergeNFT(msg.sender);
    }
     function _mergeNFT(address _user) private {
        uint _tDollar;
        uint[] memory _tkIds = getAllNFTsOwnerBy(_user);
        for(uint i = 1; i < balanceOf(_user); i++) {
            _tDollar += tokenIdToUSDT[_tkIds[i]];
            tokenIdToUSDT[_tkIds[i]] = 0;
            _approve(address(0), _tkIds[i]);
            _balances[_user] -= 1;
            toMint.push(_tkIds[i]);
            _balances[0x000000000000000000000000000000000000dEaD] += 1;
             
            _owners[_tkIds[i]] = 0x000000000000000000000000000000000000dEaD;

        }
        tokenIdToUSDT[_tkIds[0]] += _tDollar;
    }
    
    function withdraw(uint _tokenId) public {
        require(dead, "pool still alive");
        uint256 toSend = getDollarBalanceOf(_tokenId);
        require(ownerOf(_tokenId) == msg.sender, "!owner, nft");
        _transfer(msg.sender, address(this), _tokenId);
        uint256 amountInTokens = (toSend * 1e18) / priceFeed.getPriceTokenUSDT(address(token));
        require(IERC20(token).transfer(msg.sender, amountInTokens), "transfer failed, tokens!");
        emit newWithdraw(msg.sender, amountInTokens, toSend);
    }
    function distributeRewards(uint256 _amount, IERC20 _token) public {
        require(depositsClosed, "deposits still going");
        require(!dead, "pool is dead");
        uint256 balBefore = _token.balanceOf(address(this));
        require(_token.transferFrom(msg.sender, address(this), _amount));
        uint256 sent = _token.balanceOf(address(this)) - balBefore;
        uint256 rate = (sent*1e18) / tDollar;
        for(uint256 i; i < holders.length; i++) {
            uint[] memory values = new uint[](holders.length);
            values = _getValues();
            uint256 tosend = (values[i] * rate) / 1e18;
            require(_token.transfer(holders[i], tosend));
        }
        emit distRewards(msg.sender, sent, address(_token));
    }
    function getAllNFTsOwnerBy(address _add) public view returns(uint[] memory){
        uint count;
        uint[] memory _tkIds = new uint[](balanceOf(_add));
        for(uint i; i < _tokenIdCounter.current(); i++) {
            if(ownerOf(i) == _add) {
                _tkIds[count] = i;
                if(count == _tkIds.length)
                    break;
                count++;
            }
        }
        return _tkIds;
    }
    function _endDeposits() private {
        if(tDollar >= cap) {
            depositsClosed = true;
            require(IERC20(token).transfer(receiver, tToken));
        }
    }
    function updateBalances() public {
        uint ratio = (((priceFeed.getPriceTokenUSDT(address(token)) * tToken) / 1e18) * 1e18) / tDollar;
        for(uint i; i < _tokenIdCounter.current(); i++) {
            tokenIdToUSDT[i] = (tokenIdToUSDT[i] * ratio) / 1e18;
        }
    }
    function getPercentageOf(uint _tokenId) public view returns(uint) {
        return 100e18 * tokenIdToUSDT[_tokenId] / tDollar;
    }
    function getDollarBalanceOf(uint _tokenId) public view returns(uint) {
        return tokenIdToUSDT[_tokenId];
    }
    function split(uint _fromTokenId, uint _dollarAmount) public {
        require(msg.sender == ownerOf(_fromTokenId), "!owner, nft");
        require(!voteOnGoing(), "split paused while ongoing vote!");
        require(_dollarAmount >= 500e18, "500$ min!");
        require(tokenIdToUSDT[_fromTokenId] - _dollarAmount > 500e18, "500$ must be left atleast!");
        tokenIdToUSDT[_fromTokenId] -= _dollarAmount;
        if(toMint.length != 0)  {
            uint CtokenId = toMint.length-1;
            toMint.pop();
            _balances[msg.sender] += 1;
            _owners[CtokenId] = msg.sender;
            tokenIdToUSDT[CtokenId] = _dollarAmount;
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _balances[msg.sender] += 1;
        _owners[tokenId] = msg.sender;
        tokenIdToUSDT[tokenId] = _dollarAmount;
        _checkHolder(msg.sender);
    }
    function currentNFT() public view returns(uint) {
        return _tokenIdCounter.current();
    }
    struct Vote {
        uint256 end;
        string proposal;
        uint256 powerYes;
        uint256 powerNo;
    }
    mapping(uint256 => Vote) proposals; 
    mapping(uint => mapping(uint256 => bool)) hasVoted; 
    uint256 runningProposals; 
    function createProposal(uint256 _end, string calldata _proposal)
        public
        onlyOwner
    {
        require(!dead, "pool dead");
        require(depositsClosed, "deposits still going!");
        proposals[runningProposals].end = _end;
        proposals[runningProposals].proposal = _proposal;
        runningProposals++;
        emit newProposal(_proposal, runningProposals - 1);
    }
    function vote(uint256 _proposal, bool _YesOrNo, uint _tokenId) public {
        require(!dead, "pool dead");
        require(ownerOf(_tokenId) == msg.sender, "!owner, nft!");
        require(depositsClosed, "deposits still going!");
        require(voteOnGoing(), "proposal ended");
        require(!checkIfVoted(_tokenId, _proposal), "voted already!");
        hasVoted[_tokenId][_proposal] = true;
        if (_YesOrNo)
            proposals[_proposal].powerYes += tokenIdToUSDT[_tokenId];
        else
            proposals[_proposal].powerNo += tokenIdToUSDT[_tokenId];

        emit newVote(msg.sender, _proposal, _YesOrNo);
    }
    function turnDead(uint256 _proposal) public onlyOwner {
        require(!dead, "pool dead");
        require(!voteOnGoing(), "vote sill going!");
        require(proposals[_proposal].powerYes > proposals[_proposal].powerNo, "people voted no!");
        dead = true;
        emit kill(block.timestamp);
    }
    function checkIfVoted(uint _tokenId, uint256 _proposal)
        public
        view
        returns (bool)
    {
        return hasVoted[_tokenId][_proposal];
    }
    function voteOnGoing() public view returns(bool) {
        if(runningProposals != 0)
            return proposals[runningProposals-1].end > block.timestamp;
        else
            return proposals[0].end > block.timestamp;
    }
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        if(KYC) {
            require(fundFactory.isKYCed(to), "requires KYC!");
        }
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
        _transfer(from, to, tokenId);
        if(balanceOf(to) > 1)
            _mergeNFT(to);
        _checkHolder(to);
        _checkHolder(from);
    }
    function safeTransferFrom( address from, address to, uint256 tokenId) public virtual override {
        if(KYC) {
            require(fundFactory.isKYCed(to), "requires KYC!");
        }
        safeTransferFrom(from, to, tokenId, "");
    }
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
        if(KYC) {
            require(fundFactory.isKYCed(to), "requires KYC!");
        }
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
        _safeTransfer(from, to, tokenId, data);
        if(balanceOf(to) > 1)
            _mergeNFT(to);
        _checkHolder(to);
        _checkHolder(from);
    }
    
}