// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Shop {
    uint public count;
    address private owner;
    mapping(address => bool) public authorized;

    constructor() {
        count = 0;
        owner = msg.sender;
    }

    function take() public {
        require(count > 0, "Stock is empty");
        count--;
    }

    function fillStock(uint value) public returns (uint) {
        require(msg.sender == owner, "Only owner can fill stock");
        count += value;
        return count;
    }

    function addAuthorized(address user) public {
        require(msg.sender == owner, "Only owner can add authorized users");
        require(user != address(0), "Invalid address");
        authorized[user] = true;
    }

    function removeAuthorized(address user) public {
        require(msg.sender == owner, "Only owner can add authorized users");
        authorized[user] = false;
    }

    function changeOwner(address newOwner) public {
        require(msg.sender == owner, "Only owner can change owner");
        require(newOwner != address(0), "New owner should not be the zero address");
        owner = newOwner;
    }
}