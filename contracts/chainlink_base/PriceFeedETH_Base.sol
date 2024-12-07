// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumer {
    AggregatorV3Interface internal priceFeed;

    
    constructor() {
        priceFeed = AggregatorV3Interface(0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1);
    }

    function getLatestPrice() public view returns (int) {
        (
            , 
            int price, 
            , 
            , 
          
        ) = priceFeed.latestRoundData();
        return price;
    }
}