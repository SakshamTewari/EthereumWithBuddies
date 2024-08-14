// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MusicClipsToken is ERC721, Ownable {
    // Identify the current token id for recently minted token.
    uint private _tokenIds;
    constructor() ERC721("RingTones", "RTN") Ownable(msg.sender) {}

    // Auto increment the ID and assign a new tokeId to URI once minted.
    function safeMint(address to) external onlyOwner returns (uint256) {
        uint256 newItemId = _tokenIds + 1;
        _tokenIds = newItemId;
        _safeMint(to, newItemId);
        return newItemId;
    }
}
