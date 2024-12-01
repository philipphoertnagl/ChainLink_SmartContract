// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@api3/airnode-protocol/contracts/AirnodeRrpV0.sol";

contract Api3PriceConsumer is AirnodeRrpV0 {
    address public airnode; // Airnode address
    bytes32 public endpointId; // Endpoint ID for the API
    address public sponsor; // Sponsor wallet
    address public sponsorWallet; // Sponsor wallet address
    int256 public latestPrice; // Store fetched price

    // Event to log request IDs
    event Requested(bytes32 requestId);

    constructor(address _airnodeRrp) AirnodeRrpV0(_airnodeRrp) {}

    // Function to set Airnode details
    function setAirnodeDetails(
        address _airnode,
        bytes32 _endpointId,
        address _sponsorWallet
    ) external {
        airnode = _airnode;
        endpointId = _endpointId;
        sponsorWallet = _sponsorWallet;
    }

    // Function to make a request to Airnode
    function requestPrice() external {
        bytes32 requestId = makeRequest(
            airnode,
            endpointId,
            sponsorWallet,
            address(this),
            this.fulfill.selector,
            ""
        );
        emit Requested(requestId);
    }

    // Callback function to handle Airnode responses
    function fulfill(bytes32, bytes calldata data) external onlyAirnodeRrp {
        latestPrice = abi.decode(data, (int256));
    }
}
