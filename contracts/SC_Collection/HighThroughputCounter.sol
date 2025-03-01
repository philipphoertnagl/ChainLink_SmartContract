// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract HighThroughputCounter {
    uint256 public counter;

    // Event to log each increment
    event Incremented(uint256 newCounter);

  
    function increment() external {
        counter += 1;
        emit Incremented(counter);
    }
}
