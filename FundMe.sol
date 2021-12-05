// SPDX-License-Identifier: GPL-3.0

//define version 
pragma solidity ^0.6.0;

//import chainlink

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{

    using SafeMathChainlink for uint256;
    mapping(address => uint256) public addressToFundTracking;
    address[] public funders;
    address Owner;

    constructor() public {
        Owner = msg.sender;
    }

    function fund() public payable {

        //Minimum $50 
        uint256 minimumUSD = 50 * 10 ** 18;
        uint256 ValueRecievedUSD = getConversion(msg.value);
        require(ValueRecievedUSD>= minimumUSD);
        addressToFundTracking[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getConversion(uint256 ethAmount) public view returns(uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountUsd = ethPrice*ethAmount;
        return uint256(ethAmountUsd / 10000000000);
    }

    function getPrice() public view returns (uint256){
         AggregatorV3Interface priceFeed = AggregatorV3Interface(0x78F9e60608bF48a1155b4B2A5e31F32318a1d85F);
         //Tupple //unusedvariable declaration
         (,int256 answer,,,) = priceFeed.latestRoundData();
        //Typecasting
        return uint256 (answer * 10000000000);
    }

    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x78F9e60608bF48a1155b4B2A5e31F32318a1d85F);
        return priceFeed.version();
    }

    modifier onlyOwner{
        require(msg.sender == Owner);
        //Run code here
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++)
        {
            address funderAddress = funders[funderIndex];
            addressToFundTracking[funderAddress] = 0;
        }
        funders = new address[](0);
    }
}