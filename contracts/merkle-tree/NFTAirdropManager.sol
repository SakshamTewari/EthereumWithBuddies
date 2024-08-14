// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./MusicClipsToken.sol";

contract NFTAirdropManager is Ownable {
    /// Libraries decelartions
    using MerkleProof for bytes[];
    using BitMaps for BitMaps.BitMap;

    /// Roothash for state root(Merkle root)
    bytes32 public airDropWhiteListMerkleRoot;

    /// Track the claim status
    BitMaps.BitMap private _mintedStatus;

    /// Token - NFT
    MusicClipsToken _nftToken;

    constructor(bytes32 _rootHash, address _nft) Ownable(msg.sender) {
        airDropWhiteListMerkleRoot = _rootHash;
        _nftToken = MusicClipsToken(_nft);
    }

    /// Update root when new address added
    function updateMerkleRoot(
        bytes32 _airDropWhiteListMerkleRoot
    ) public onlyOwner {
        airDropWhiteListMerkleRoot = _airDropWhiteListMerkleRoot;
    }

    function mint(
        bytes32[] calldata _proof,
        uint _index,
        address _toAddress
    ) external {
        /// User has not minted
        require(!_mintedStatus.get(_index), "Address has already minted");

        /// Create leaf node from sender's address
        bytes32 leaf = keccak256(abi.encodePacked(_toAddress));

        /// Verify the leaf against the Merkle root
        require(
            MerkleProof.verify(_proof, airDropWhiteListMerkleRoot, leaf),
            "Not a whitelisted address"
        );

        /// Mark as minted
        _mintedStatus.set(_index);

        /// Mint the NFT here
        _nftToken.safeMint(_toAddress);
    }
}
