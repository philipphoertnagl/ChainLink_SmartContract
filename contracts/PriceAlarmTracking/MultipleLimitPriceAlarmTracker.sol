// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceAlertSystem {
    struct Asset {
        address priceFeed;
        int256 priceLimit;
        bool priceLimitReached;
    }

    mapping(string => Asset) public assets;

    event PriceLimitReached(string asset, int256 price, uint256 timestamp);

    // adding asset and define price limit
    function addAsset(string memory name, address priceFeed, int256 priceLimit) public {
        require(priceFeed != address(0), "Invalid price feed address");
        require(assets[name].priceFeed == address(0), "Asset already exists");

        assets[name] = Asset(priceFeed, priceLimit, false);
    }



    // to update the price limit
    function updateThreshold(string memory name, int256 newThreshold) public {
        require(assets[name].priceFeed != address(0), "Asset not found");
        assets[name].priceLimit = newThreshold;
        assets[name].priceLimitReached = false;
    }

    function checkPrice(string memory name) public {
        Asset storage asset = assets[name];
        require(asset.priceFeed != address(0), "Asset not found");

        AggregatorV3Interface priceFeed = AggregatorV3Interface(asset.priceFeed);
        (, int256 price,, uint256 updatedAt,) = priceFeed.latestRoundData();

        if (!asset.priceLimitReached && price >= asset.priceLimit) {
            asset.priceLimitReached = true;
            emit PriceLimitReached(name, price, updatedAt);
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
