// Initialize Web3
const web3 = new Web3(window.BinanceChain || 'https://bsc-dataseed.binance.org/');

// Contract address and ABI
const contractAddress = 'YOUR_CONTRACT_ADDRESS';
const contractABI = [
  // Paste your contract's ABI here
];

// Instantiate the contract
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Function to get invested pool IDs
async function getInvestedPoolIds() {
  try {
    // Prompt user to connect their wallet
    await window.BinanceChain.enable();

    // Get the current user's address
    const accounts = await web3.eth.getAccounts();
    const userAddress = accounts[0];

    // Call the contract's getInvestedIdsOf function
    const investedIds = await contract.methods.getInvestedIdsOf(userAddress).call();
    document.getElementById('myPoolsID').innerHTML = 'Your invested pool IDs are:' + investedIds;
  } catch (error) {
    alert('Error:', error);
  }
}