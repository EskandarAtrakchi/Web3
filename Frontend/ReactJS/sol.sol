// SPDX-License-Identifier: MIT

library Counters {
    struct Counter {
        
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}


/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() {
        _transferOwnership(_msgSender());
    }
    modifier onlyOwner() {
        _checkOwner();
        _;
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}
interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool _approved) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}
interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;
    string private _name;
    string private _symbol;
    mapping(uint256 => address) internal _owners;
    mapping(address => uint256) internal _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not token owner nor approved for all"
        );

        _approve(to, tokenId);
    }
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        _requireMinted(tokenId);

        return _tokenApprovals[tokenId];
    }
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");

        _transfer(from, to, tokenId);
    }
    function safeTransferFrom(
        address from,de {
        safeTransferFrom(from, to, tokenId, "");
    }
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
        _safeTransfer(from, to, tokenId, data);
    }
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);
        _approve(address(0), tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
        _afterTokenTransfer(from, to, tokenId);
    }
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }
    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}
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
            }
        }
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
    function currentNFT() public view returns(uint) {
        return _tokenIdCounter.current();
    }
    struct Vote {
        uint256 end;
        string proposal;
        uint256 powerYes;
        uint256 powerNo;
    }
    mapping(uint256 => Vote) proposals; //id to proposal
    mapping(uint => mapping(uint256 => bool)) hasVoted; //if user has voted on proposal
    uint256 runningProposals; // latest proposal id
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
        address to,
        uint256 tokenId
    ) public virtual override {
        if(KYC) {
            require(fundFactory.isKYCed(to), "requires KYC!");
        }
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