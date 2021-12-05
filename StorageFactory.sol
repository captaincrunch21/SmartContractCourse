// SPDX-License-Identifier: GPL-3.0

//define version 
pragma solidity >=0.6.0 <0.9.0;

import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage{
    //Array of contracts
    SimpleStorage[] public simpleStorageArray;

    //Creates a new SimpleStorage Contract and save it in array
    function createSimpleStorageContact() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageindex, uint256 _simpleStorageNumber) public{
        //get Address from the Array
        SimpleStorage simpleStorage =  SimpleStorage(address(simpleStorageArray[_simpleStorageindex]));
        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageindex) public view returns (uint256){
        //get Address from the array
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageindex]));
        return simpleStorage.retrieve();
    }
}
