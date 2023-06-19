<script>
        // Connect to the Binance Smart Chain using Web3
        const web3 = new Web3("https://bsc-xxxxxxxxxxxx");

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

        // Get the user's wallet address
        async function getUserAddress() {
            const accounts = await web3.eth.getAccounts();
            return accounts[0];
        }

        // Function to populate the user's wallet address in the input field
        async function populateUserAddress() {
            const userAddressInput = document.getElementById('userAddress');
            userAddressInput.value = await getUserAddress();
        }

        // Call the populatePoolIds function to populate the pool IDs on page load
        populatePoolIds();

        // Populate the user's wallet address on page load
        populateUserAddress();

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
                // Call the join pool function in the smart contract
                const result = await factoryContract.methods.joinPool(userAddress, poolId, fundsAmount).send({ from: userAddress });

                // Handle the transaction result
                console.log(result);
            } catch (error) {
                console.error(error);
                // Handle error
            }
        }

        // Attach the event listener to the form submission
        document.getElementById('joinPoolForm').addEventListener('submit', joinPool);

        // Function to connect the user's wallet
        async function connectWallet() {
            if (window.ethereum) {
                try {
                    await window.ethereum.request({ method: 'eth_requestAccounts' });
                    // Refresh the user's address after connecting the wallet
                    populateUserAddress();
                } catch (error) {
                    console.error('Failed to connect wallet:', error);
                }
            } else {
                console.error('Please install MetaMask to connect your wallet.');
            }
        }
    </script>