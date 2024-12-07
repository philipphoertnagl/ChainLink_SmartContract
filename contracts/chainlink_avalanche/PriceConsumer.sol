// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumer {
    AggregatorV3Interface internal priceFeed;


    constructor() {
        priceFeed = AggregatorV3Interface(0x86d67c3D38D2bCeE722E601025C25a575021c6EA);
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