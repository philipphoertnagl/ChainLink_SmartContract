// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol"; 
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract OnChainStringVRF is VRFConsumerBaseV2 {
    using Strings for uint256;

    VRFCoordinatorV2Interface COORDINATOR;
    uint64 public s_subscriptionId;
    bytes32 public keyHash;
    uint32 public callbackGasLimit = 100000;
    uint16 public requestConfirmations = 3;
    uint32 public numWords = 1;

    uint256 public s_requestId;
    string public randomString;

    event RandomStringRequested(uint256 requestId);
    event RandomStringFulfilled(uint256 requestId, uint256 randomWord, string randomString);

    /**
     * @param subscriptionId The VRF subscription ID.
     * @param vrfCoordinator The address of the VRF Coordinator.
     * @param _keyHash The gas lane key hash.
     */
    constructor(
        uint64 subscriptionId,
        address vrfCoordinator,
        bytes32 _keyHash
    )
        VRFConsumerBaseV2(vrfCoordinator)
    {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_subscriptionId = subscriptionId;
        keyHash = _keyHash;
    }

    /// @notice Requests a random number; the result is stored as a string.
    function requestRandomString() external returns (uint256 requestId) {
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requestId = requestId;
        emit RandomStringRequested(requestId);
        return requestId;
    }

    /// @notice Called by the VRF Coordinator with the random number.
    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        // Convert the first random word to string.
        randomString = randomWords[0].toString();
        emit RandomStringFulfilled(requestId, randomWords[0], randomString);
    }
}
