// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceAlertSystem {
    struct Asset {
        address priceFeed;
        int256 priceThreshold;
        bool thresholdReached;
    }

    mapping(string => Asset) public assets;

    event ThresholdReached(string asset, int256 price, uint256 timestamp);

   
    function addAsset(string memory name, address priceFeed, int256 priceThreshold) public {
        require(priceFeed != address(0), "Invalid price feed address");
        require(assets[name].priceFeed == address(0), "Asset already exists");

        assets[name] = Asset(priceFeed, priceThreshold, false);
    }

    function checkPrice(string memory name) public {
        Asset storage asset = assets[name];
        require(asset.priceFeed != address(0), "Asset not found");

        AggregatorV3Interface priceFeed = AggregatorV3Interface(asset.priceFeed);
        (, int256 price,, uint256 updatedAt,) = priceFeed.latestRoundData();

        if (!asset.thresholdReached && price >= asset.priceThreshold) {
            asset.thresholdReached = true;
            emit ThresholdReached(name, price, updatedAt);
        }
    }

  
    function getLatestPrice(string memory name) public view returns (int256) {
        Asset storage asset = assets[name];
        require(asset.priceFeed != address(0), "Asset not found");

        AggregatorV3Interface priceFeed = AggregatorV3Interface(asset.priceFeed);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return price;
    }
}
