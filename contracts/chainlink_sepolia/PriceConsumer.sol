// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumer {
    AggregatorV3Interface internal priceFeed;

    //address of the price feed (ETH/USD on Sepolia)
    constructor() {
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function getLatestPrice() public view returns (int) {
        (
            , 
            int price, // get latest price
            , 
            , 
          
        ) = priceFeed.latestRoundData();
        return price;
    }
}