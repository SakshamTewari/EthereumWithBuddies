// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./MusicClipsToken.sol";
import "./NFTCommitReveal.sol";

contract NFTAirdropManager is Ownable {
    /// Libraries decelartions
    using MerkleProof for bytes[];
    using BitMaps for BitMaps.BitMap;

    event PaymentWithdrawalSuccess(address user, uint payment);

    bool public isPublicSale;

    mapping(address => uint) public owner2bal;

    /// Root-hash for state root(Merkle root)
    bytes32 public airDropWhiteListMerkleRoot;

    /// Track the claim status
    BitMaps.BitMap private _mintedStatus;

    /// Token - NFT
    MusicClipsToken _nftToken;

    /// Commit reavel
    NFTCommitReveal _commitReveal;

    constructor(
        bytes32 _rootHash,
        address _nft,
        address _commitAddress
    ) Ownable(msg.sender) {
        airDropWhiteListMerkleRoot = _rootHash;
        _nftToken = MusicClipsToken(_nft);
        _commitReveal = NFTCommitReveal(_commitAddress);
    }

    modifier preSaleActive {
        require(!isPublicSale, "in Public Sale");
        _;
    }

    /// Update root when new address added
    function updateMerkleRoot(
        bytes32 _airDropWhiteListMerkleRoot
    ) public onlyOwner {
        airDropWhiteListMerkleRoot = _airDropWhiteListMerkleRoot;
    }

    function commitMint(uint _salt) external preSaleActive {
        require(!isPublicSale, "Pre-Sale has ended.");
        _commitReveal.commit(msg.sender, keccak256(abi.encodePacked(msg.sender, _salt)));
    }

    function revealCommit(uint _salt) external preSaleActive {
        _commitReveal.reveal(msg.sender,_salt);
    }


    function claim(bytes32[] calldata _proof, uint _index) external preSaleActive {
        require(
            _commitReveal.reveledDetails(msg.sender),
            "Please reveal your commit"
        );

        bytes32 randomNftId = keccak256(
            abi.encodePacked(block.prevrandao, block.timestamp)
        );

        /// User has not minted
        require(!_mintedStatus.get(_index), "Address has already minted");

        /// Create leaf node from sender's address
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));

        /// Verify the leaf against the Merkle root
        require(
            MerkleProof.verify(_proof, airDropWhiteListMerkleRoot, leaf),
            "Not a whitelisted address"
        );

        /// Mark status as minted
        _mintedStatus.set(_index);

        /// Mint the NFT here
        _nftToken.safeMint(msg.sender, uint256(randomNftId));
    }

    function buyTokensInPublicSale(address _owner, uint _tokenId) external payable  {
        require(_nftToken.hasSupply(),"Public Sale has ended as Supply has Exhausted");
        // buy nft
        _nftToken.safeMint(_owner, _tokenId);
        //update the owner2bal map
        owner2bal[_owner] += msg.value;
        
    }

    function withdrawFunds(address desginatedOwner) public {
        // check the count of tokens/nfts in owner2bal
        require(owner2bal[desginatedOwner] > 0, "InSufficient tokens");
        // send or send a pull request to owner
        uint balInEth = owner2bal[desginatedOwner];
        (bool success, ) = msg.sender.call{value: balInEth}("");
        require(success, "Payment failed.");
        emit PaymentWithdrawalSuccess(msg.sender, balInEth);
    }

    function setPublicSaleActive() public {
        isPublicSale = true;
    }

    // assumption - private sale has ended
    // in public sale
    // any user can buy nft
    // once nft is bought, owner2bal mapping is updated
    // whenever user wants to withdraw
    // he can call the withdraw function and get the funds
    // ================= Only thing we need to investigate , how to send a push request for withdraw ===================

}


// The NFT should use a state machine to determine if it is mints can happen, 
// the presale is active, or the public sale is active, or the supply has run out. 
// Require statements should only depend on the state (except when checking input validity)

// Add State Machine
// isPreSaleActive = Y/N
// isPublicSaleActive = Y/n
