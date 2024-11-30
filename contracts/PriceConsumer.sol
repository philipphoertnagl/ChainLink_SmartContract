pragma solidity ^0.8.0;

// Import the Chainlink Aggregator interface
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumer {
    AggregatorV3Interface internal priceFeed;

    // Constructor sets the address of the price feed (ETH/USD on Sepolia)
    constructor() {
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    // Function to fetch the latest price
    function getLatestPrice() public view returns (int) {
        (
            , 
            int price, // latest price
            , 
            , 
          
        ) = priceFeed.latestRoundData();
        return price;
    }
}