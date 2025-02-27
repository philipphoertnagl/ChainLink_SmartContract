// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title Extended Arbitrage Benchmarking Contract
 * @notice Tracks Chainlink price updates, gas costs, and network efficiency.
 */
contract ExtendedArbitrageBenchmark {
    AggregatorV3Interface private priceFeed;

    int256 public latestPrice;
    uint256 public lastUpdated;
    uint256 public lastGasUsed;
    uint80 public lastRoundId;
    int256 public priceChange; // % change since last update
    uint256 public timeSinceLastUpdate;

    event PriceUpdated(uint80 roundId, int256 price, uint256 timestamp, int256 change, uint256 gasUsed);

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

   function updatePrice() public {
    uint256 startGas = gasleft();

    // Fetch data from Chainlink oracle
    (uint80 roundId, int256 price,, uint256 updatedAt,) = priceFeed.latestRoundData();
    require(price > 0, "Invalid price data");

    // Store previous values before updating
    int256 previousPrice = latestPrice; 
    uint256 previousUpdated = lastUpdated;

    // Store new values
    latestPrice = price;
    lastUpdated = updatedAt;
    lastGasUsed = startGas - gasleft();
    lastRoundId = roundId;

    // Calculate % change and time since last update
    if (previousPrice > 0) { // Ensure no division by zero
        priceChange = ((price - previousPrice) * 10**8) / previousPrice; // Scale up to keep precision
        timeSinceLastUpdate = updatedAt - previousUpdated;
    }

    emit PriceUpdated(roundId, price, updatedAt, priceChange, lastGasUsed);
}


    function getBenchmarkData() public view returns (
        uint80, int256, uint256, int256, uint256, uint256
    ) {
        return (lastRoundId, latestPrice, lastUpdated, priceChange, timeSinceLastUpdate, lastGasUsed);
    }

    function getOracleRawData() public view returns (uint80, int256, uint256) {
    (uint80 roundId, int256 price,, uint256 updatedAt,) = priceFeed.latestRoundData();
    return (roundId, price, updatedAt);
}


}
