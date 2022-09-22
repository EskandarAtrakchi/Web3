// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {
    
    struct PeopleNo {
        uint256 Number;
    }
    struct PeopleName {
        string Name;
    }

    PeopleNo[] public peopleNo;
    PeopleName[] public peopleName;

    function storeName (string memory _name) public {
        peopleName.push(PeopleName(_name));
    }
    function storeNumber (uint256 _Number) public {
        peopleNo.push(PeopleNo(_Number));
    }
}
