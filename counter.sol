// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CounterCalculator {
    uint public count;

    constructor() {
        count = 0;
    }

    function increment() public {
        count += 1;
    }

    function decrement() public {
        require(count > 0, "Count cannot be less than zero");
        count -= 1;
    }

    function add(uint value) public returns (uint) {
        count += value;
        return count;        
    }

    function subtract(uint value) public returns (uint) {
        require(count >= value, "Result cannot be less than zero");
        count -= value;
        return count;
    }

    function multiply(uint value) public returns (uint) {
        count *= value;
        return count;
    }
    
    function divide(uint value) public returns (uint) {
        require(value > 0, "Cannot divide by zero");
        count /= value;
        return count;
    }

    function reset() public {
        count = 0;
    }
}