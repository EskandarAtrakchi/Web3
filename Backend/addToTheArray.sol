//SPDX-License-Identifier: MIT
//here is to declare the virsion
pragma solidity 0.8.8;

contract SimpleStorage {
    //This gets initilized to zero 
    uint256 favoriteNumber;
    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    //uint256[] public favoritNumberList;
    People[] public people;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
        
    } 
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    //adding to the array, People[] public people;
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;

    }
}
//0xd9145CCE52D386f254917e481eB44e9943F39138
