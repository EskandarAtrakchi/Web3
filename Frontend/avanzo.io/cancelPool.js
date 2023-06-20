// Initialize Web3
const web3 = new Web3(window.ethereum);

// Contract address and ABI
const contractAddress = 'YOUR_CONTRACT_ADDRESS';
const contractABI = [
  // Paste your contract's ABI here
];

// Instantiate the contract
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Function to cancel a pool
async function cancelPool() {
  try {
    // Prompt user to connect their wallet
    await window.ethereum.enable();

    // Get the input values
    const poolId = parseInt(document.getElementById('poolId').value);
    const proposalId = parseInt(document.getElementById('proposalId').value);

    // Call the contract's endPoolsOf function
    await contract.methods.endPoolsOf([poolId], [proposalId]).send();

    console.log('Pool cancelled successfully!');
  } catch (error) {
    console.error('Error:', error);
  }
}