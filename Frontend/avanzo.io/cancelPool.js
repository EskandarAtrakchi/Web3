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
/*
The HTML code provides a user interface for the owner to input the pool ID and proposal ID of the pool they want to cancel.
When the owner clicks the "Cancel Pool" button, the cancelPool() JavaScript function is invoked.
The JavaScript code initializes Web3 and connects to the user's wallet using the window.ethereum object.
It retrieves the pool ID and proposal ID entered by the owner from the input fields in the HTML.
The cancelPool() function then calls the endPoolsOf function of the smart contract, passing the pool ID and proposal ID as arguments.
If the transaction is successful, the console log message "Pool cancelled successfully!" is displayed. Otherwise, an error message is logged.
*/