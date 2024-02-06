//Important NOTE:  include the necessary getNFTsPrice.js, MarketPlace.js, and WalletConnect.js files for the functionality to work correctly.

// Connect to the Binance Smart Chain using Web3
const web3 = new Web3("https://bsc-xxxxxxxxxxxx");

// Set the contract address and ABI
const contractAddress = 'MARKETPLACE_CONTRACT_ADDRESS';
const contractABI = ['...']; // Your MarketPlace contract's ABI

// Get the contract instance
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Function to populate the available NFTs
async function populateNFTs() {

  try {

    // Get all sale IDs of NFTs
    const saleIds = await contract.methods.getSaleIdsOfNFT(contractAddress).call();

    // Get the sale info for each sale ID
    const nftSelect = document.getElementById('nftSelect');
    //nftSelect.innerHTML = ''; // Clear the select options

    for (let i = 0; i < saleIds.length; i++) {

      const saleId = saleIds[i];

      // Get the sale info for the sale ID
      const saleInfo = await contract.methods.getSaleInfo(saleId).call();

      // Create an option element for the NFT
      const option = document.createElement('option');
      option.value = saleId;
      option.textContent = `NFT ${saleId} - Price: ${saleInfo[2]} ETH`;
      nftSelect.appendChild(option);

    }

  } 
  
  catch (error) {

    console.error(error);
    // Handle error

  }

}

// Function to populate the user's NFTs
async function populateMyNFTs() {

  try {

    // Get the user's address
    const userAddress = await web3.eth.getCoinbase();

    // Get the balance of NFTs owned by the user
    const balance = await contract.methods.balanceOf(userAddress).call();

    // Get the token IDs of the user's NFTs
    const myNFTs = [];
    for (let i = 0; i < balance; i++) {
      const tokenId = await contract.methods.tokenOfOwnerByIndex(userAddress, i).call();
      myNFTs.push(tokenId);

    }

    // Display the user's NFTs in the HTML
    const myNFTsList = document.getElementById('myNFTs');
    myNFTsList.innerHTML = ''; // Clear the list

    myNFTs.forEach((tokenId) => {

      const listItem = document.createElement('li');
      listItem.textContent = `NFT ${tokenId}`;
      myNFTsList.appendChild(listItem);

    });

  } 
  
  catch (error) {

    console.error(error);
    // Handle error

  }

}

// Function to handle form submission for selling NFT
async function sellNFT(event) {

  event.preventDefault();

  // Get the form inputs
  const tokenAddressInput = document.getElementById('tokenAddress');
  const tokenIdInput = document.getElementById('tokenId');
  const priceInput = document.getElementById('price');

  const tokenAddress = tokenAddressInput.value;
  const tokenId = tokenIdInput.value;
  const price = priceInput.value;

  try {

    // Call the setOnSale function in the smart contract
    await contract.methods.setOnSale(tokenAddress, tokenId, price).send({ from: web3.eth.defaultAccount });

    // Display success message to the user
    alert('NFT successfully listed for sale');

    // Refresh the list of available NFTs
    await populateNFTs();

  } 
  
  catch (error) {

    console.error(error);
    // Handle error

  }

}

// Function to handle form submission for buying NFT
async function buyNFT(event) {

  event.preventDefault();

  // Get the selected sale ID from the select element
  const nftSelect = document.getElementById('nftSelect');
  const saleId = nftSelect.value;

  try {

    // Call the buyNFT function in the smart contract
    await contract.methods.buyNFT(saleId).send({ from: web3.eth.defaultAccount });

    // Display success message to the user
    alert('NFT successfully purchased');

    // Refresh the list of available NFTs and user's NFTs
    await populateNFTs();
    await populateMyNFTs();

  } 
  
  catch (error) {

    console.error(error);
    // Handle error

  }
  
}

// Attach the event listener to the form submission for selling NFT
document.getElementById('sellForm').addEventListener('submit', sellNFT);

// Attach the event listener to the form submission for buying NFT
document.getElementById('buyForm').addEventListener('submit', buyNFT);

// Populate the available NFTs and user's NFTs on page load
populateNFTs();
populateMyNFTs();

/*
Get NFT Price:
The user can enter a token ID and click the "Get Dollar Balance" button.
The JavaScript function getDollarBalance() is triggered, which retrieves the price of the NFT associated with the given token ID.
The result is displayed on the page.
Sell NFT:
The user can enter the NFT address, NFT ID, and set the price for their NFT.
When the user clicks the "Sell NFT" button, the JavaScript function sellNFT() is called.
The function calls the setOnSale function in the smart contract, passing the provided NFT address, NFT ID, and price.
If the transaction is successful, an alert is displayed to the user, and the list of available NFTs is refreshed.
Buy NFT:
The user can select an NFT from the dropdown menu that displays the NFTs available for sale by other users.
After selecting an NFT, the user clicks the "Buy NFT" button.
The JavaScript function buyNFT() is called.
The function calls the buyNFT function in the smart contract, passing the selected sale ID.
If the transaction is successful, an alert is displayed to the user, and the list of available NFTs and the user's NFTs are refreshed.
My NFTs:
The code includes a section labeled "My NFTs" that displays the NFTs owned by the connected wallet.
The function populateMyNFTs() retrieves the user's address and gets the balance of NFTs owned by the user.
It then displays the user's NFTs on the page.
*/