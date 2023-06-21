// Connect to BSC using Web3
const web3 = new Web3("https://bsc-dataseed.binance.org/");

// Retrieve the address of the deployed FundFactory contract on the BSC network
const factoryAddress = "0x14c68be85fCfff02604A47f3d3cff956a515C613"; // FundFactory contract address

// FundFactory ABI
const factoryABI = [
    // ... interface ABI
];

// Create an instance of the FundFactory contract
const factoryContract = new web3.eth.Contract(factoryABI, factoryAddress);

// Function to create a new fund pool
async function createFundPool(event) {

    event.preventDefault();

    //I have committed the values in $ USD in other web3.js files, so it is important to keep it as USD stablecoins.
    //IMPORTANT NOTE: It might be a better idea to keep it as BUSD stablecoin terms and not keep changing with other stablecoins, such as USDT and USD  
    const tokenAddress = document.getElementById("tokenAddress").value;
    const teamAddress = document.getElementById("teamAddress").value;
    const cap = document.getElementById("cap").value;
    const kyc = document.getElementById("kyc").value === "true";

    try {

        // Perform KYC check here if needed
        // if (!isKYCed) {
        //     console.log("User is not verified (KYC status is false)");
        //     return;
        // }

        //keep the KYC thing for later (Ask the CEO if he reall wants to check users for their KYC status)
        //Note: I can hard code the address here send({ from: web3.eth.defaultAccount }) instead of web3.eth.defaultAccount
        await factoryContract.methods.createFundPool(tokenAddress, teamAddress, cap, kyc).send({ from: web3.eth.defaultAccount });

        const runningCount = await factoryContract.methods.runningCount().call();
        const fundPoolAddress = await factoryContract.methods.getAddressOfId(runningCount - 1).
        call();
        const fundPoolId = runningCount - 1; // Calculate the pool ID
        const fundPoolAddressElement = document.getElementById("fundPoolAddress");
        fundPoolAddressElement.innerHTML = `Fund Pool Address: ${fundPoolAddress}<br>Pool ID: ${fundPoolId}`;

    } 
    
    catch (error) {

        console.error(error);

    }

}

// Attach the event listener to the form submission
document.getElementById("createFundPoolForm").addEventListener("submit", createFundPool);
/*
The HTML code provides a user interface for the owner to input the pool ID and proposal ID of the pool they want to cancel.
When the owner clicks the "Cancel Pool" button, the cancelPool() JavaScript function is invoked.
The JavaScript code initializes Web3 and connects to the user's wallet using the window.ethereum object.
It retrieves the pool ID and proposal ID entered by the owner from the input fields in the HTML.
The cancelPool() function then calls the endPoolsOf function of the smart contract, passing the pool ID and proposal ID as arguments.
If the transaction is successful, the console log message "Pool cancelled successfully!" is displayed. Otherwise, an error message is logged.
*/
