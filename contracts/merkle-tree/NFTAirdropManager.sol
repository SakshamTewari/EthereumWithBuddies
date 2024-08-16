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

    /// Update root when new address added
    function updateMerkleRoot(
        bytes32 _airDropWhiteListMerkleRoot
    ) public onlyOwner {
        airDropWhiteListMerkleRoot = _airDropWhiteListMerkleRoot;
    }

    function commitMint(uint _salt) external {
        _commitReveal.commit(msg.sender, keccak256(abi.encodePacked(msg.sender, _salt)));
    }

    function revealCommit(uint _salt) external {
        _commitReveal.reveal(msg.sender,_salt);
    }

    function claim(bytes32[] calldata _proof, uint _index) external {
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
}
