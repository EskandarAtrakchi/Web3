// this file is connected to Marketplace

async function getDollarBalance() {

    const tokenId = document.getElementById('tokenId').value;
    const contractAddress = 'BUSD_CONTRACT_ADDRESS'; // BUSD contract address
    const contractABI = [
        // ABI here for the BUSD token contract
    ];

    const web3 = new Web3(window.ethereum);
    const contract = new web3.eth.Contract(contractABI, contractAddress);

    try {

        const balance = await contract.methods.getDollarBalanceOf(tokenId).call();
        document.getElementById('result').innerText = `Dollar Balance: ${balance}`;
        
    } 
    
    catch (error) {

        console.error(error);
        document.getElementById('result').innerText = 'Error occurred while getting the balance.';
    }

}

// Connect to the user's MetaMask or other BSC wallet
async function connectWallet() {

    try {

        if (window.ethereum) {

            await window.ethereum.request({ method: 'eth_requestAccounts' });
            console.log('Wallet connected');
        
        } 
        
        else {

            console.error('No wallet detected');
        
        }
        
    } 
    
    catch (error) {

        console.error(error);
    
    }

}

window.addEventListener('DOMContentLoaded', () => {
    connectWallet();
});