// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MusicClipsToken is ERC721, Ownable {
    // Identify the current token id for recently minted token.
    uint private _tokenCount;
    uint public MAX_NO_NFTS = 1000;
    address public nftOwner;
    constructor() ERC721("RingTones", "RTN") Ownable(msg.sender) {
        nftOwner = msg.sender;
    }

    // Auto increment the ID and assign a new tokeId to URI once minted.
    function safeMint(
        address to,
        uint _nftId
    ) external {
        uint256 newItemId = _tokenCount + 1;
        require(newItemId <= MAX_NO_NFTS, "MAX Nft has been minted");
        _tokenCount = newItemId;
        _safeMint(to, _nftId);
    }

    function hasSupply() public view returns (bool){
        return _tokenCount < MAX_NO_NFTS;
    }
}
