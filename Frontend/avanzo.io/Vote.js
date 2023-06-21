//There is mapping function in solidity, so pool ID should be enough for the voting button to work properly
window.addEventListener('DOMContentLoaded', async () => {
// Check if Web3 is available
if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    console.error('Web3 not found. Please make sure MetaMask is installed.');
    return;
}

// Get the contract instance
const contractAddress = 'CONTRACT_ADDRESS'; // Replace with your actual contract address
const contractABI = []; // Replace with your actual contract ABI
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Update the vote percentage display
updateVotePercentage();

// Function to vote on the pool
window.vote = async () => {
    const poolId = document.getElementById('poolId').value;

    // Call the vote function in the contract
    try {
    const accounts = await web3.eth.requestAccounts();
    const fromAddress = accounts[0];

    await contract.methods.vote(poolId).send({ from: fromAddress });
    console.log('Vote successful');
    alert('Vote successful');
    updateVotePercentage();
    } catch (error) {
    console.error('Vote failed:', error);
    alert('Vote failed. Please check the console for details.');
    }
};

// Function to update the vote percentage display
async function updateVotePercentage() {
    const poolId = document.getElementById('poolId').value;

    // Call the getVotePercentage function in the contract
    try {
    const votePercentage = await contract.methods.getVotePercentage(poolId).call();
    document.getElementById('votePercentage').textContent = `${votePercentage}%`;
    } catch (error) {
    console.error('Failed to get vote percentage:', error);
    }
}
});