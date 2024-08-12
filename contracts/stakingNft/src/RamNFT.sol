// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;


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

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract RamNFT is ERC721{

    uint256 public nextTokenId;
    address public admin;

    constructor() ERC721("Ram NFT", "RNFT"){
        admin = msg.sender;
    }

    function mintNFT(address to) public {
        require(msg.sender == admin, "only admin can mint");
        _safeMint(to,nextTokenId);
        nextTokenId++;
    }
}