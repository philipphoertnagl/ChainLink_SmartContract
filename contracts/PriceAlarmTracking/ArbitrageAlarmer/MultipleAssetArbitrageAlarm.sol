// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract ArbitragePriceAlert {
    
    struct Asset {
        address[] priceFeeds;             // List of price feed addresses for the asset
        int256 arbitrageThreshold;          // Threshold for detecting arbitrage (e.g., in absolute price units)
        bool arbitrageOpportunityDetected;  // Flag to mark if an arbitrage opportunity has been detected
    }
    
    // Mapping from asset name to its data
    mapping(string => Asset) public assets;
    
    // Events to log important actions
    event AssetAdded(string asset);
    event PriceFeedsUpdated(string asset);
    event ArbitrageOpportunityDetected(string asset, int256 minPrice, int256 maxPrice, uint256 timestamp);
    
    /**
     * @notice Registers a new asset with multiple price feeds and an arbitrage threshold.
     * @param name The name of the asset.
     * @param _priceFeeds An array of Chainlink price feed addresses.
     * @param _arbitrageThreshold The minimum difference between the highest and lowest price to trigger an alert.
     */
    function addAsset(string memory name, address[] memory _priceFeeds, int256 _arbitrageThreshold) public {
        require(_priceFeeds.length > 0, "At least one price feed required");
        // Ensure that the asset does not already exist
        require(assets[name].priceFeeds.length == 0, "Asset already exists");
        // Check that each provided price feed address is valid
        for (uint256 i = 0; i < _priceFeeds.length; i++){
            require(_priceFeeds[i] != address(0), "Invalid price feed address");
        }
        
        assets[name] = Asset({
            priceFeeds: _priceFeeds,
            arbitrageThreshold: _arbitrageThreshold,
            arbitrageOpportunityDetected: false
        });
        
        emit AssetAdded(name);
    }
    
    /**
     * @notice Updates the list of price feeds for a given asset.
     * @param name The name of the asset.
     * @param _priceFeeds An updated array of Chainlink price feed addresses.
     */
    function updatePriceFeeds(string memory name, address[] memory _priceFeeds) public {
        require(assets[name].priceFeeds.length > 0, "Asset not found");
        require(_priceFeeds.length > 0, "At least one price feed required");
        for (uint256 i = 0; i < _priceFeeds.length; i++){
            require(_priceFeeds[i] != address(0), "Invalid price feed address");
        }
        assets[name].priceFeeds = _priceFeeds;
        assets[name].arbitrageOpportunityDetected = false;
        emit PriceFeedsUpdated(name);
    }
    
    /**
     * @notice Updates the arbitrage threshold for an asset.
     * @param name The name of the asset.
     * @param _newThreshold The new arbitrage threshold.
     */
    function updateArbitrageThreshold(string memory name, int256 _newThreshold) public {
        require(assets[name].priceFeeds.length > 0, "Asset not found");
        assets[name].arbitrageThreshold = _newThreshold;
        assets[name].arbitrageOpportunityDetected = false;
    }
    
    /**
     * @notice Checks for arbitrage opportunities by comparing the latest prices from all feeds.
     * If the difference between the maximum and minimum price is above the threshold,
     * an event is emitted.
     * @param name The name of the asset.
     */
    function checkArbitrage(string memory name) public {
        Asset storage asset = assets[name];
        require(asset.priceFeeds.length > 0, "Asset not found");
        
        // Initialize minPrice to the highest possible value and maxPrice to the lowest possible value.
        int256 minPrice = type(int256).max;
        int256 maxPrice = type(int256).min;
        
        // Loop through each price feed and retrieve the latest price.
        for (uint256 i = 0; i < asset.priceFeeds.length; i++){
            AggregatorV3Interface priceFeed = AggregatorV3Interface(asset.priceFeeds[i]);
            (, int256 price, , , ) = priceFeed.latestRoundData();
            
            if (price < minPrice) {
                minPrice = price;
            }
            if (price > maxPrice) {
                maxPrice = price;
            }
        }
        
        // If the difference exceeds the arbitrage threshold, mark the opportunity and emit an event.
        int256 priceDiff = maxPrice - minPrice;
        if (priceDiff >= asset.arbitrageThreshold) {
            asset.arbitrageOpportunityDetected = true;
            emit ArbitrageOpportunityDetected(name, minPrice, maxPrice, block.timestamp);
        }
    }
    
    /**
     * @notice Returns the latest prices from all feeds for a given asset.
     * @param name The name of the asset.
     * @return An array of latest prices from the respective price feeds.
     */
    function getLatestPrices(string memory name) public view returns (int256[] memory) {
        Asset storage asset = assets[name];
        require(asset.priceFeeds.length > 0, "Asset not found");
        
        int256[] memory prices = new int256[](asset.priceFeeds.length);
        for (uint256 i = 0; i < asset.priceFeeds.length; i++){
            AggregatorV3Interface priceFeed = AggregatorV3Interface(asset.priceFeeds[i]);
            (, int256 price, , , ) = priceFeed.latestRoundData();
            prices[i] = price;
        }
        return prices;
    }
}
