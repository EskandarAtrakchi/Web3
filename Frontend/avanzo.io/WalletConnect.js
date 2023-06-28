/*
This code is responsible for connecting to Metamask on the Binance Smart Chain (BSC) and updating the button text with the connected address.

getWeb3 is an asynchronous function that returns a promise. It checks if the window.ethereum object is available, which indicates that Metamask is installed.

If Metamask is available, it creates a new instance of the Web3 object using window.ethereum. It then tries to add the Binance Smart Chain (BSC) configuration to Metamask using the wallet_addEthereumChain method.

If the BSC chain is added successfully, it retrieves the connected accounts using web3.eth.getAccounts() and resolves the promise with the web3 object and the accounts array.

If there's an error during the connection process, it rejects the promise with the error.

The DOMContentLoaded event listener waits for the HTML document to be fully loaded. It attaches a click event listener to the connect button.

When the connect button is clicked, it calls the getWeb3 function to connect to Metamask and retrieves the web3 object and the connected accounts.

It extracts the first account from the accounts array and trims the address to the first 8 characters followed by ellipsis.

The button text is updated with the trimmed connected address, and the successful connection is logged to the console.

If there's an error during the connection process, it alerts the error message.
*/


const getWeb3 = async () => { //await is expected here 
  return new Promise(async (resolve, reject) => {

    if (typeof window.ethereum !== 'undefined') {

      const web3 = new Web3(window.ethereum);
      try {

        await window.ethereum.request({// await defined 

          method: "wallet_addEthereumChain",
          //adding BSC chain
          params: [
            {
              chainId: "0x38", // Binance Smart Chain Mainnet
              chainName: "Binance Smart Chain",
              nativeCurrency: {
                name: "BNB",
                symbol: "bnb",
                decimals: 18,
              },
              rpcUrls: ["https://bsc-dataseed.binance.org/"],
              blockExplorerUrls: ["https://bscscan.com/"],
            },
          ],
        });

        const accounts = await web3.eth.getAccounts();
        resolve({ web3, accounts });

      } 
      
      catch (error) {// reject error 

        reject('The error is :' + error);

      }

    } 
    
    else {

      reject(new Error("Metamask provider not found"));

    }

  });

};

document.addEventListener("DOMContentLoaded", () => {//DOMContentLoaded event is fired when content is loaded to get the metamask 

  const connectButton = document.getElementById("BTNTESTART");

  connectButton.addEventListener("click", async () => {

    try {

      const { web3, accounts } = await getWeb3();
      const connectedAddress = accounts[0];
      connectButton.textContent = connectedAddress.substring(0, 8) + "...";//trim the address 
      alert("Web3 connected:", web3);

    } 
    
    catch (error) {//alert the error
      alert("Error connecting to Web3:", error);

    }

  });

});