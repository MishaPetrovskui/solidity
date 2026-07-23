// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DAO {
    struct Proposal {
        string description;
        uint votesFor;
        uint votesAgainst;
        bool closed;
    }

    address[] public directors;
    mapping(address => bool) public isDirector;
    Proposal[] public proposals;
    mapping(uint => mapping(address => bool)) public hasVoted;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this");
        _;
    }

    modifier onlyDirector() {
        require(isDirector[msg.sender], "Only director can do this");
        _;
    }

    function addDirector(address director) public onlyOwner {
        require(!isDirector[director], "This is director");
        isDirector[director] = true;
        directors.push(director);
    }

    function removeDirector(address director) public onlyOwner {
        require(isDirector[director], "This is not director");
        isDirector[director] = false;
    }

    function createProposal(string calldata discription) public onlyDirector returns (uint) {
        proposals.push(Proposal({
            description: discription,
            votesFor: 0,
            votesAgainst: 0,
            closed: false
        }));
        return proposals.length - 1; 
    }

    function vote(uint proposalId, bool support) public onlyDirector {
        require(proposalId < proposals.length, "Proposal does not exist");
        require(!proposals[proposalId].closed, "Proposal is closed");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        hasVoted[proposalId][msg.sender] = true;

        if (support) {
            proposals[proposalId].votesFor++;
        } else {
            proposals[proposalId].votesAgainst++;
        }
    }

    function getResult(uint proposalId) public view returns (string memory description, uint votesFor, uint votesAgainst, bool accepted) {
        require(proposalId < proposals.length, "Proposal does not exist");
        Proposal memory p = proposals[proposalId];
        return (p.description, p.votesFor, p.votesAgainst, p.votesFor > p.votesAgainst);
    }

    function getAllProposals() public view returns (Proposal[] memory) {
        return proposals;
    }

    function getProposalsCount() public view returns (uint) {
        return proposals.length;
    }
}