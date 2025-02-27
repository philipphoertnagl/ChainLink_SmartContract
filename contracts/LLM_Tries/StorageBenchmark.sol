// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Storage Efficiency Benchmarking Contract
 * @notice Measures gas costs for storing and retrieving different data sizes.
 */
contract StorageBenchmark {
    struct DataEntry {
        bytes data;  // Stores any data (small, medium, large)
        uint256 timestamp;  // Stores the time of storage
        uint256 gasUsed; // Gas cost for storing the data
    }

    mapping(uint256 => DataEntry) public storedData;
    uint256 public dataCounter;

    event DataStored(uint256 indexed id, uint256 dataSize, uint256 gasUsed);
    
    /**
     * @notice Stores data and tracks gas cost.
     * @param _data The data to store (small, medium, large).
     */
    function storeData(bytes memory _data) public {
        uint256 startGas = gasleft();

        storedData[dataCounter] = DataEntry({
            data: _data,
            timestamp: block.timestamp,
            gasUsed: startGas - gasleft()
        });

        emit DataStored(dataCounter, _data.length, storedData[dataCounter].gasUsed);
        dataCounter++;
    }

    /**
     * @notice Retrieves stored data (costs gas but does not modify blockchain).
     * @param _id The ID of the stored data.
     * @return The stored data, timestamp, and gas used.
     */
function retrieveData(uint256 _id) public view returns (string memory, uint256, uint256) {
    require(_id < dataCounter, "Invalid ID");

    string memory decodedData = string(storedData[_id].data); // Convert bytes to string

    return (
        decodedData, // Human-readable text
        storedData[_id].timestamp,
        storedData[_id].gasUsed
    );
    }
}
