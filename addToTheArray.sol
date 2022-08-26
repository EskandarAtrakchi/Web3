//SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

contract SimpleStorage {
    //This gets initilized to zero 
    uint256 ContractNumber;

    struct People {
        uint256 ContractNumber;
        string name;
    }

    //uint256[] public ContractNumberOne;
    People[] public people;

    function store(uint256 ContractNumberOne) public {
        ContractNumber = ContractNumberOne;
        
    }
    function retrieve() public view returns(uint256){
        return ContractNumber;
    }

    //adding to the array, People[] public people;
    function addPerson(string memory _name, uint256 ContractNumberOne) public {
        people.push(People(ContractNumberOne, _name));

    }
}
//0xd9145CCE52D386f254917e481eB44e9943F39138
