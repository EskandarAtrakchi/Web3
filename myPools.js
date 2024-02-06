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
/*
When the user clicks on the "Click Me" button, the getInvestedPoolIds() function is called.
The function prompts the user to connect their wallet.
After connecting the wallet, the user's address is obtained.
The contract's getInvestedIdsOf function is called to retrieve the pool IDs associated with the user's address.
The obtained pool IDs are displayed on the webpage.
*/