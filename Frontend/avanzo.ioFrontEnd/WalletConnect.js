// Function to connect the user's wallet
async function connectWallet() {
    if (window.BinanceChain) {
      try {
        await window.BinanceChain.enable();
        // Refresh the user's address after connecting the wallet
        populateUserAddress();
      } catch (error) {
        console.error('Failed to connect wallet:', error);
      }
    } else {
      console.error('Please install Binance Chain Wallet to connect your wallet.');
    }
}
  
// Function to populate the user's wallet address in the input field
async function populateUserAddress() {
    const userAddressInput = document.getElementById('userAddress');
    const userAddress = await getUserAddress();
  
    // Truncate the address to a desired length
    const truncatedAddress = truncateAddress(userAddress, 8); // Specify the desired length here
    
    userAddressInput.value = truncatedAddress;
}
  
  // Helper function to truncate the address
function truncateAddress(address, length) {
    if (address.length <= length) {
      return address;
    }
    
    const start = address.substr(0, length / 2);
    const end = address.substr(address.length - length / 2);
    return `${start}...${end}`;
}
  