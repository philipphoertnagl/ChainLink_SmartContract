// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract SimplePriceFeed {
    AggregatorV3Interface internal priceFeed;

    int256 public lastPrice;
    uint256 public lastTimestamp;

    event PriceUpdated(int256 newPrice, uint256 timestamp);

   
    constructor(address _priceFeedAddress) {
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    /**
     * @dev Manually fetch the latest price from the aggregator and store it.
     *      In typical usage, you'd call this function periodically (or from a script).
     */
    function updatePrice() public {
        (
            uint80 roundID,
            int256 price,
            ,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        require(answeredInRound >= roundID, "Stale data from aggregator");

        lastPrice = price;
        lastTimestamp = updatedAt;

        emit PriceUpdated(price, updatedAt);
    }

    /**
     * @dev Return the current Chainlink aggregator price on demand (without storing it).
     */
    function getLatestPrice() external view returns (int256) {
        (
            ,
            int256 price,
            ,
            ,
            
        ) = priceFeed.latestRoundData();
        return price;
    }
}
