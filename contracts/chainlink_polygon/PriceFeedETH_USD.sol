// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumer {
    AggregatorV3Interface internal priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(0xF0d50568e3A7e8259E16663972b11910F89BD8e7);
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