// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumer {
    AggregatorV3Interface internal priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(0xCA50964d2Cf6366456a607E5e1DBCE381A8BA807); // ETH/USD
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