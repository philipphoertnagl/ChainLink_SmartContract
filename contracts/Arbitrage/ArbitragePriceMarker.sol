// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title Arbitrage Benchmarking Contract
 * @notice Fetches Chainlink ETH/USD price, records gas costs, and allows off-chain benchmarking.
 */
contract ArbitrageBenchmark {
    AggregatorV3Interface private priceFeed;
    
    int256 public latestPrice;
    uint256 public lastUpdated;
    uint256 public lastGasUsed;

    event PriceUpdated(int256 price, uint256 timestamp, uint256 gasUsed);

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    /**
     * @notice Fetches the latest ETH/USD price from Chainlink and records benchmarking data.
     */
    function updatePrice() public {
        uint256 startGas = gasleft();
        
        (, int256 price,, uint256 updatedAt,) = priceFeed.latestRoundData();
        require(price > 0, "Invalid price data");

        latestPrice = price;
        lastUpdated = updatedAt;
        lastGasUsed = startGas - gasleft();

        emit PriceUpdated(price, updatedAt, lastGasUsed);
    }

    /**
     * @notice Returns the latest stored price, timestamp, and gas cost of last update.
     */
    function getBenchmarkData() public view returns (int256, uint256, uint256) {
        return (latestPrice, lastUpdated, lastGasUsed);
    }
}
