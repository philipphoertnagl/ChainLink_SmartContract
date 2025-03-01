// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract OnChainStorageTest {

    // State variables to store different sizes of data
    string public shortData;
    string public mediumData;
    string public largeData;

    // Events to log data (cheaper than storing all data in state, 
    // but not readable on-chain by other contracts
    event ShortDataStored(string data);
    event MediumDataStored(string data);
    event LargeDataStored(string data);

 
    function storeShortData(string memory _data) external {
        shortData = _data;
        emit ShortDataStored(_data);
    }


    function storeMediumData(string memory _data) external {
        mediumData = _data;
        emit MediumDataStored(_data);
    }


    function storeLargeData(string memory _data) external {
        largeData = _data;
        emit LargeDataStored(_data);
    }
}
