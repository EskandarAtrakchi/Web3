async function getNFTsOwnedByUser() {

    // Get the contract instance
    const fundFactoryAddress = "0x8CE38aaeb020E6c5fC5782493427894dCc6778A4";
    import fundFactoryABI from './contractsABIs/FundFactoryABI.js';
    import avanzoNFTABI from './contractsABIs/avanzoNFTABI.js';
  
    // Get the contract instance for the specified pool
    const fundFactoryContract = new web3.eth.Contract(fundFactoryABI, fundFactoryAddress);
    const poolAddress = await fundFactoryContract.methods.getAddressOfId(poolId).call();
    const poolContract = new web3.eth.Contract(avanzoNFTABI, poolAddress);
  
    // Get the user's account address
    const accounts = await web3.eth.requestAccounts();
    const userAddress = accounts[0];
  
    // Call the balanceOf function to get the number of NFTs owned by the user
    const balance = await poolContract.methods.balanceOf(userAddress).call();
  
    // Loop through the user's NFTs and retrieve their IDs
    const nftIds = [];
    
    for (let i = 0; i < balance; i++) {

        const nftId = await poolContract.methods.tokenOfOwnerByIndex(userAddress, i).call();
        nftIds.push(nftId);

        // Create a new HTML element for each NFT ID and append it to the page
        const nftElement = document.createElement('div');
        nftElement.textContent = `NFT ID: ${nftId}`;
        document.body.appendChild(nftElement);

    }
  
    return nftIds;

}
  
window.vote = async (vote) => {

    const poolId = document.getElementById('poolId').value;
    const proposalId = document.getElementById('proposalId').value;
    const nftId = document.getElementById('nftId').value;

    // Get the contract instance for the specified pool
    const fundFactoryContract = new web3.eth.Contract(fundFactoryABI, fundFactoryAddress);
    const poolAddress = await fundFactoryContract.methods.getAddressOfId(poolId).call();
    const poolContract = new web3.eth.Contract(avanzoNFTABI, poolAddress);

    // Call the vote function in the contract
    try {
        const accounts = await web3.eth.requestAccounts();
        const fromAddress = accounts[0];

        await poolContract.methods.vote(proposalId, vote, nftId).send({ from: fromAddress });
        console.log('Vote successful');
        alert('Vote successful');
    } catch (error) {
        console.error('Vote failed:', error);
        alert('Vote failed. Please check the console for details.');
    }
};