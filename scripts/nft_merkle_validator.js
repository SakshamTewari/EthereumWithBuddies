
console.log("Merkle verifier........");

const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");


let whitelistedAddresses = [
   "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
   "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",
   "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB",
   "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
];

const leafs = whitelistedAddresses.map(addr => keccak256(addr));
console.log(leafs);
const merkleTree = new MerkleTree(leafs, keccak256, {sortPairs: true});

const rootHash = merkleTree.getRoot();
console.log("tree", merkleTree.toString());
console.log("rootHash", rootHash);



/// claiming NFT
const claimingAddr = leafs[0];
const hexProof = merkleTree.getHexProof(claimingAddr);
console.log("hexProof", hexProof);