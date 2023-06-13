// app.js

// Example JavaScript functions for interacting with the smart contract

// Transfer Ownership
function transferOwnership() {
    const newOwnerInput = document.getElementById('newOwnerInput');
    const newOwnerAddress = newOwnerInput.value;
  
    // Perform the transfer ownership operation
    // Assuming you have a reference to the smart contract instance named 'marketplaceContract'
  
    // Call the transferOwnership function on the smart contract
    marketplaceContract.transferOwnership(newOwnerAddress)
      .then((result) => {
        // The transfer ownership transaction was successful
        console.log('Ownership transferred successfully');
        // You can perform additional actions here, such as updating the UI or displaying a success message
      })
      .catch((error) => {
        // There was an error transferring ownership
        console.error('Error transferring ownership:', error);
        // You can handle the error here, such as displaying an error message to the user
      });
  }
  
  
  // Transfer Receiver Address
  function transferRReceiver() {
    const newReceiverInput = document.getElementById('newReceiverInput');
    const newReceiverAddress = newReceiverInput.value;
  
    // Perform the transfer receiver operation
    // Assuming you have a reference to the smart contract instance named 'marketplaceContract'
  
    // Call the transferRReceiver function on the smart contract
    marketplaceContract.transferRReceiver(newReceiverAddress)
      .then((result) => {
        // The transfer receiver transaction was successful
        console.log('Receiver transferred successfully');
        // You can perform additional actions here, such as updating the UI or displaying a success message
      })
      .catch((error) => {
        // There was an error transferring the receiver
        console.error('Error transferring receiver:', error);
        // You can handle the error here, such as displaying an error message to the user
      });
  }
  
  
  // Sell NFT
  function setOnSale() {
    const tokenInput = document.getElementById('tokenInput');
    const tokenIdInput = document.getElementById('tokenIdInput');
    const priceInput = document.getElementById('priceInput');
    const tokenAddress = tokenInput.value;
    const tokenId = tokenIdInput.value;
    const price = priceInput.value;
  
    // Perform the set on sale operation
    // Assuming you have a reference to the smart contract instance named 'marketplaceContract'
  
    // Call the setOnSale function on the smart contract
    marketplaceContract.setOnSale(tokenAddress, tokenId, price)
      .then((result) => {
        // The set on sale transaction was successful
        console.log('NFT set on sale successfully');
        // You can perform additional actions here, such as updating the UI or displaying a success message
      })
      .catch((error) => {
        // There was an error setting the NFT on sale
        console.error('Error setting NFT on sale:', error);
        // You can handle the error here, such as displaying an error message to the user
      });
  }
  
  
  // Buy NFT
  function buyNFT() {
    const orderIdInput = document.getElementById('orderIdInput');
    const orderId = orderIdInput.value;
  
    // Perform the buy NFT operation
    // Assuming you have a reference to the smart contract instance named 'marketplaceContract'
  
    // Call the buyNFT function on the smart contract
    marketplaceContract.buyNFT(orderId)
      .then((result) => {
        // The buy NFT transaction was successful
        console.log('NFT bought successfully');
        // You can perform additional actions here, such as updating the UI or displaying a success message
      })
      .catch((error) => {
        // There was an error buying the NFT
        console.error('Error buying NFT:', error);
        // You can handle the error here, such as displaying an error message to the user
      });
  }
  
  
  // Revoke Sale
  function revokeSell() {
    const revokeOrderIdInput = document.getElementById('revokeOrderIdInput');
    const revokeOrderId = revokeOrderIdInput.value;
  
    // Perform the revoke sale operation
    // Assuming you have a reference to the smart contract instance named 'marketplaceContract'
  
    // Call the revokeSell function on the smart contract
    marketplaceContract.revokeSell(revokeOrderId)
      .then((result) => {
        // The revoke sale transaction was successful
        console.log('Sale revoked successfully');
        // You can perform additional actions here, such as updating the UI or displaying a success message
      })
      .catch((error) => {
        // There was an error revoking the sale
        console.error('Error revoking sale:', error);
        // You can handle the error here, such as displaying an error message to the user
      });
  }
  
  
  // Get Sale IDs of NFT
  function getSaleIdsOfNFT() {
    const nftTokenInput = document.getElementById('nftTokenInput');
    const nftTokenAddress = nftTokenInput.value;
  
    // Perform the get sale IDs of NFT operation
    // Assuming you have a reference to the smart contract instance named 'marketplaceContract'
  
    // Call the getSaleIdsOfNFT function on the smart contract
    marketplaceContract.getSaleIdsOfNFT(nftTokenAddress)
      .then((saleIds) => {
        // Successfully retrieved the sale IDs of the NFT
        console.log('Sale IDs:', saleIds);
        // You can perform additional actions here, such as updating the UI with the sale IDs
      })
      .catch((error) => {
        // There was an error retrieving the sale IDs
        console.error('Error getting sale IDs:', error);
        // You can handle the error here, such as displaying an error message to the user
      });
  }
  
  
  // Get Sale Info
  function getSaleInfo() {
    const saleIdInput = document.getElementById('saleIdInput');
    const saleId = saleIdInput.value;
  
    // Perform the get sale info operation
    // Assuming you have a reference to the smart contract instance named 'marketplaceContract'
  
    // Call the getSaleInfo function on the smart contract
    marketplaceContract.getSaleInfo(saleId)
      .then((saleInfo) => {
        // Successfully retrieved the sale info
        console.log('Sale Info:', saleInfo);
        // You can perform additional actions here, such as updating the UI with the sale info
      })
      .catch((error) => {
        // There was an error retrieving the sale info
        console.error('Error getting sale info:', error);
        // You can handle the error here, such as displaying an error message to the user
      });
  }
  
  
  // Check if NFT is on Sale
  function isOnSale() {
    const checkTokenInput = document.getElementById('checkTokenInput');
    const checkTokenIdInput = document.getElementById('checkTokenIdInput');
    const checkTokenAddress = checkTokenInput.value;
    const checkTokenId = checkTokenIdInput.value;
  
    // Perform the is on sale operation
    // Assuming you have a reference to the smart contract instance named 'marketplaceContract'
  
    // Call the isOnSale function on the smart contract
    marketplaceContract.isOnSale(checkTokenAddress, checkTokenId)
      .then((result) => {
        const [isOnSale, price] = result;
        // Successfully retrieved the is on sale result
        console.log('Is On Sale:', isOnSale);
        console.log('Price:', price);
        // You can perform additional actions here, such as updating the UI based on the is on sale result
      })
      .catch((error) => {
        // There was an error checking if the NFT is on sale
        console.error('Error checking if NFT is on sale:', error);
        // You can handle the error here, such as displaying an error message to the user
      });
  }
  