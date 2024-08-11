// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract MyERC721 is ERC721{

    event MintedNFT(address _receiver);

    uint private tokenID;
    constructor() ERC721("M721","My721"){
        // _mint(msg.sender, tokenID);
    }

    function mintNFT(address _sender) public {
        _mint(_sender, tokenID);
        tokenID++ ;
        emit MintedNFT(msg.sender);
    }
}