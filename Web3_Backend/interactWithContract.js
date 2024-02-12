const { ethers } = require("ethers");

// SepoliaETH RPC endpoint
const rpcEndpoint = "YOUR_SEPOLIAETH_RPC_ENDPOINT";
const privateKey = "YOUR_PRIVATE_KEY";

const provider = new ethers.providers.JsonRpcProvider(rpcEndpoint);
const wallet = new ethers.Wallet(privateKey, provider);

// FundFactory contract address (replace with your deployed contract address)
const fundFactoryAddress = "YOUR_FUNDFACTORY_CONTRACT_ADDRESS";

// FundFactory ABI (replace with your ABI)
const fundFactoryABI = [
  // ... Copy and paste your ABI here
];

const fundFactoryContract = new ethers.Contract(fundFactoryAddress, fundFactoryABI, wallet);

async function main() {
  try {
    // Example: Call a view function
    const marketPlaceAddress = await fundFactoryContract.marketPlace();
    console.log("Marketplace Address:", marketPlaceAddress);

    // Example: Sending a transaction (make sure to replace parameters)
    // const newTokenAddress = "0x1234567890123456789012345678901234567890";
    // const newTeamAddress = "0xabcdefabcdefabcdefabcdefabcdefabcdefabcdef";
    // const newCap = 1000000;
    // const newKYC = true;
    // await fundFactoryContract.createFundPool(newTokenAddress, newTeamAddress, newCap, newKYC);
    // console.log("Fund Pool created successfully!");

    // Example: Wait for the transaction to be mined
    // const receipt = await transaction.wait();
    // console.log("Transaction mined:", receipt);

    // Add more interactions as needed

  } catch (error) {
    console.error("Error:", error);
  }
}

main();
