// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract NFTCommitReveal {
    mapping(address => bytes32) public commits;
    mapping(address => bool) public reveledDetails;
    mapping(address => uint256) public reveledBlockDetails;

    event CommitMade(
        address indexed user,
        bytes32 commitHash,
        uint256 revealBlock
    );

    event Revealed(address indexed user, string mintCode);

    function commit(bytes32 _commitHash) external {
        //require(commits[msg.sender] == 0, "Already committed");
        commits[msg.sender] = _commitHash;
        reveledBlockDetails[msg.sender] = block.number + 10;
        emit CommitMade(
            msg.sender,
            _commitHash,
            reveledBlockDetails[msg.sender]
        );
    }

    function reveal(bytes32 _commitedHash) external {
        bool isRevealed = reveledDetails[msg.sender];
        require(!isRevealed, "Already revealed");

        uint revealBlock = reveledBlockDetails[msg.sender];

        /// Need to identiyf why reavelBlock should be ahead of commit block
        require(block.number >= revealBlock, "Reveal not yet allowed");

        // Recreate the hash to verify
        bytes32 expectedHash = keccak256(abi.encodePacked(_commitedHash));
        bytes32 actualHash = commits[msg.sender];
        require(expectedHash == actualHash, "Invalid reveal");

        reveledDetails[msg.sender] = true;
    }
}
