// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract TimeLock {

    function withdraw(uint256 Time) public payable returns(int256){
        return int256(Time - block.timestamp);
    }
}


