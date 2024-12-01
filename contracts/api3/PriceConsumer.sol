// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Api3PriceConsumer {
    address public airnode; // Airnode address
    bytes32 public endpointId; // Endpoint ID for the API
    address public sponsor; // Sponsor wallet
    address public sponsorWallet; // Sponsor wallet address
    address public airnodeRrp; // Airnode RRP address
    int256 public latestPrice; // Store fetched price

    // Event to log request IDs
    event Requested(bytes32 requestId);

    // Modifier to restrict access to the Airnode RRP
    modifier onlyAirnodeRrp() {
        require(msg.sender == airnodeRrp, "Caller is not the Airnode RRP");
        _;
    }

    // Constructor to initialize the Airnode RRP address
    constructor(address _airnodeRrp) {
        airnodeRrp = _airnodeRrp;
    }

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
        bytes32 requestId = keccak256(
            abi.encodePacked(
                airnode,
                endpointId,
                sponsorWallet,
                address(this),
                this.fulfill.selector
            )
        );
        emit Requested(requestId);
    }

    // Callback function to handle Airnode responses
    function fulfill(bytes32, bytes calldata data) external onlyAirnodeRrp {
        latestPrice = abi.decode(data, (int256));
    }
}
