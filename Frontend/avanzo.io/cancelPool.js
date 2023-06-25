// Initialize Web3
const web3 = new Web3(window.ethereum);

// Contract address and ABI
const FundFactorycontractAddress = 'CONTRACT_ADDRESS';
const FundFactorycontractABI = [
  // contract's ABI here
];
const AvanzoNFTcontractAddress = 'AVANZO_NFT_ADVERTIS';
const AvanzoNFTcontractABI = [
  // contract's ABI here
];

//// Instantiate the AvanzoNFTcontract
const AvanzoNFTcontract = new web3.eth.Contract(AvanzoNFTcontractABI, AvanzoNFTcontractAddress);
// Instantiate the FundFactorycontract
const FundFactorycontract = new web3.eth.Contract(FundFactorycontractABI, FundFactorycontractAddress);

// Function to cancel a pool
async function cancelPool() {
  try {
    // Prompt user to connect their wallet
    await window.ethereum.enable();

    // Get the input values
    const poolId = parseInt(document.getElementById('poolId').value);
    const proposalId = parseInt(document.getElementById('proposalId').value);

    // Call the contract's endPoolsOf function
    await FundFactorycontract.methods.endPoolsOf([poolId], [proposalId]).send();

    console.log('Pool cancelled successfully!');
    alert('Pool cancelled successfully!');
  } catch (error) {
    console.error('Error:', error);
  }
}

async function WithdrawPool() {

  const tokenId = ""; // The ID of the token to withdraw
  await AvanzoNFTcontract.methods.withdraw(tokenId).send({ from: userAddress });

}
/*
When the owner clicks the "Cancel Pool" button, the cancelPool() JavaScript function is invoked.
The JavaScript code initializes Web3 and connects to the user's wallet using the window.ethereum object.
It retrieves the pool ID and proposal ID entered by the owner from the input fields in the HTML.
The cancelPool() function then calls the endPoolsOf function of the smart contract, passing the pool ID and proposal ID as arguments.
If the transaction is successful, the console log message "Pool cancelled successfully!" is displayed. Otherwise, an error message is logged.
*/