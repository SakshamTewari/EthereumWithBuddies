// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./MyERC20.sol";
import "./MyERC721.sol";


// pricing condition
    // 1 erc20 = 1 nft
    
    // mint, 
    // 1. check erc20 tokens
    // 2. if bal > and purchase token < bal
    // 3. mint nft's

contract AnotherERC20 is ERC20{

    MyERC20 private myerc20;
    MyERC721 private myerc721;
    //owner has ERC20
    mapping(address => uint) public ownerToMyERC20;
    //owner has NFT
    mapping(address => uint) public ownerToMyERC721;


    // Since this is a 3rd party/authoritative contract, 
    // all transactions between MyERC20 and MyERC721 handled by this contract
    constructor(address _myerc20address, address _myerc721address) ERC20("M20","My20"){
        
        // address reference of MyERC20 contract
        myerc20 = MyERC20(_myerc20address);
        // address reference of MyERC721 contract
        myerc721 = MyERC721(_myerc721address);
        _mint(msg.sender, 1000e18);
    }

    // Mint MyERC20 tokens
    function mint_MyERC20(uint _tokensToMint) public {
        myerc20.mintToken(msg.sender, _tokensToMint);
        ownerToMyERC20[msg.sender] = _tokensToMint;
    }

    function mint_MyERC721(uint _erc20Tokens) public {

        // check if the balance of erc20 is greater than requested
        require(ownerToMyERC20[msg.sender] >= _erc20Tokens, "Insufficient balance");

        // since the balance is sufficient, mint nfts
        myerc721.mintNFT(msg.sender);

        // update the mapping of erc721
        ownerToMyERC721[msg.sender] = _erc20Tokens;
    }


}