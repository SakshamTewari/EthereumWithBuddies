// SPDX-License-Identifier: SEE LICENSE IN LICENSE

// 

pragma solidity ^0.8.18;

import "./RamNFT.sol";
import "./RamERC20.sol";

contract AdminController {
    RamERC20 public erc20;
    RamNFT public erc721;

    // mapping to store user address and its tokenId
    mapping(uint => address) public ownerToTokenId;

    // owner of erc20 contract
    address public ownerERC20;

    // owner of erc721 contract
    address public ownerERC721;

    address public saksham = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    constructor(address ramErc20, address ramnft) {
        ownerERC20 = ramErc20;
        ownerERC721 = ramnft;
        erc20 = RamERC20(ramErc20);
        erc721 = RamNFT(ramnft);
    }

    // write a function to mint
    function buyErc20(address owner, uint256 noOfTokens) public {
        erc20.mintToken(owner, noOfTokens);
    }

    // write a function to mint NFT's
    function buyNft(address owner, uint256 noOfNfts) public {
        require(erc20.balanceOf(owner) >= noOfNfts, "Insufficient balance");
        // buy 1 NFT for 1 Token
        erc721.mintNFT(owner);

        // transfer from owner to contract owner
    }

    // write a workflow to create a new ERC20 token and then buy NFT's
    // i want to buy 10 tokens and 1 NFT = 10 tokens

    // Saksham wants to 1 NFT (721)
    // Shobit is the owner of ERC20
    // Ram in between in manageing the transaction 

    // transfer 1 token to shobit and deduct 1 from saksham

    function getERC20AndBuyNFT() public {
        // Saksham wants to buy 10 tokens
        // Shobit has transfer 10 token to saksham
        // now ask Ram to buy on behalf of saksham for 1 NFT
        // add balance 1 token to shobit and deduct 1 from saksham
        // Saksham now iwll have 1 NFT balance
        buyErc20(saksham,10);
        buyNft(saksham, 1);
    }

    // Stacking and Rewards
    
    function send_nft_for_staking(address _user, uint _tokenId) public {
        ownerToTokenId[_tokenId] = _user;
    }

    // Withdraw NFTs

    function withdraw_nft_rewards(address _user, uint _tokenId) public {

        // when you withdraw
                // - transfer of erc20 tokens
        require(ownerToTokenId[_tokenId] == _user, "You are not the owner");

        erc20.allowance(ownerERC20, address(this));

        erc20.transferFrom(ownerERC20, _user, 10);
    }
}