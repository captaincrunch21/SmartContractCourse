// SPDX-License-Identifier: GPL-3.0

//define version 
pragma solidity >=0.6.0 <0.9.0;


/**
*   @title SimpleStorage
*   @dev Store a number 
**/
contract SimpleStorage{
    
    struct People{
        uint256 numberStored;
        string name;
    }

    People[] public people;

    //default initalization will be 0
    uint256 private numberStored ;

    mapping(string => uint256) public nameToStoredNumber;

    /**
    *   @dev Assign the numberStored
    **/
    function store(uint256 _numberStored) public{
        numberStored = _numberStored;
    }

    function retrieve() public view returns(uint256){
        return numberStored;
    }

    function addPerson(string memory _name, uint256 _numberStored) public{
        people.push(People({numberStored:_numberStored, name:_name}));
        nameToStoredNumber[_name] = _numberStored;
    }
}
