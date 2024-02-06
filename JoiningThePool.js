// Connect to the Binance Smart Chain using Web3
const web3 = new Web3("https://bsc-dataseed.binance.org");

// Set the contract address and ABI
const factoryAddress = 'FACTORY_CONTRACT_ADDRESS';
const factoryABI = ['...']; // Your factory contract's ABI

// Get the factory contract instance
const factoryContract = new web3.eth.Contract(factoryABI, factoryAddress);

// Function to retrieve and populate the pool IDs in the form
async function populatePoolIds() {
    
  const poolIds = await factoryContract.methods.getPools().call();
  const poolIdSelect = document.getElementById('poolId');
  
  // Clear any existing options
  poolIdSelect.innerHTML = '';

  // Create and append the option elements
  poolIds.forEach(poolId => {

    const option = document.createElement('option');
    option.value = poolId;
    option.text = poolId;
    poolIdSelect.appendChild(option);

  });

}

// Call the populatePoolIds function to populate the pool IDs on page load
populatePoolIds();

// Function to handle form submission
async function joinPool(event) {

  event.preventDefault();
  
  // Get the user's input from the form
  const userAddress = document.getElementById('userAddress').value;
  const poolId = document.getElementById('poolId').value;
  const fundsAmount = document.getElementById('fundsAmount').value;
  
  // Validate funds amount
  if (fundsAmount < 0) {

    console.error("Invalid funds amount");
    // Display an error message to the user
    return;

  }
  
  try {

    // Call the join pool function in the factory contract
    const result = await factoryContract.methods.joinPool(userAddress, poolId, fundsAmount).send({ from: userAddress });
    
    // Handle the transaction result
    console.log(result);

  } 
  
  catch (error) {

    console.error(error);
    // Handle error

  }

}

// Attach the event listener to the form submission
document.getElementById('joinPoolForm').addEventListener('submit', joinPool);
    
/*
When the user connects their wallet, the "User Address" field is automatically filled with the address of their connected wallet.
The available pools are retrieved from the smart contract and displayed as options in the "Pool ID" dropdown menu. The user can select one of the pools.
The user can enter the amount of funds they want to contribute to the selected pool in the "Funds Amount" field.
When the user clicks the "Join Pool" button, the joinPool() function is triggered. It retrieves the user's input values (user address, pool ID, and funds amount).
The function then interacts with the smart contract by calling the joinPool() function, passing the user's input values as arguments.
If the transaction is successful, the transaction result is logged to the console.
*/