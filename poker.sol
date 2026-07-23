// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Poker {
    uint public money;
    address public croupier;
    address[] public players;
    mapping(address => bool) public isPlayer;
    mapping(address => uint) public price;

    constructor() {
        croupier = msg.sender;
    }

    modifier onlyCroupier() {
        require(msg.sender == croupier, "Only croupier can do this");
        _;
    }

    modifier onlyPlayer() {
        require(isPlayer[msg.sender], "Only player can do this");
        _;
    }

    function addPlayer(address player) public onlyCroupier {
        require(!isPlayer[player], "Already player");
        isPlayer[player] = true;
        players.push(player);
    }

    function removePlayer(address player) public onlyCroupier {
        _removePlayer(player);
    }

    function pass() public onlyPlayer {
        _removePlayer(msg.sender);
    }

    function _removePlayer(address player) private {
        require(isPlayer[player], "Not a player");
        isPlayer[player] = false;
        price[player] = 0;

        for (uint i = 0; i < players.length; i++) {
            if (players[i] == player) {
                players[i] = players[players.length - 1];
                players.pop();
                break;
            }
        }
    }

    function getMaxPrice() public view returns (uint) {
        uint max = 0;
        for (uint i = 0; i < players.length; i++) {
            if (price[players[i]] > max) {
                max = price[players[i]];
            }
        }
        return max;
    }

    function makeParlay() public payable onlyPlayer {
        uint maxPrice = getMaxPrice();
        require(price[msg.sender] + msg.value >= maxPrice, "Parlay is lower than max price");
        price[msg.sender] += msg.value;
        money += msg.value;
    }

    function allParlayEqual() public view returns(bool) {
        if (players.length == 0) return true;
        uint first = price[players[0]];
        for (uint i = 1; i < players.length; i++) {
            if (price[players[i]] != first) return false;
        }
        return true;
    }

    function payout(address winner) public onlyCroupier {
        require(isPlayer[winner], "Winner must be a player");
        uint amount = money;
        money = 0;

        for (uint i = 0; i < players.length; i++) {
            price[players[i]] = 0;
        }

        (bool success, ) = winner.call{value: amount}("");
        require(success, "Payout failed");
    }
}