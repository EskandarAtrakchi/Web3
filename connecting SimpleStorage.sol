//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//connecting SimpleStorage.sol
import "./SimpleStorage.sol"; 

contract StorageFactory {

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        
        SimpleStorage simpleStorage = new SimpleStorage();
         simpleStorageArray.push(simpleStorage);

    }
}
