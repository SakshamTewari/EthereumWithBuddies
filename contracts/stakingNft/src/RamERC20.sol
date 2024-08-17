// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;


// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volitility coin

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RamERC20 is ERC20 {

    address public owner;

    // total supply of 1000 tokens with 18 decimals
    constructor() ERC20("Ram token", "RAM"){
        owner = msg.sender;
       _mint(msg.sender, 1000e18); // Initial supply of 1,000,000 tokens to the contract deployer

    }

    function mintToken(address sender, uint256 noOfTokens) public {
            _mint(sender,noOfTokens);
    }
}