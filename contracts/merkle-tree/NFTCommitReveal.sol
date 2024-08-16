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

    function commit(address msgSender, bytes32 _commitHash) external {
        //require(commits[msg.sender] == 0, "Already committed");
        commits[msgSender] = _commitHash;
        reveledBlockDetails[msgSender] = block.number + 1;
        emit CommitMade(
            msgSender,
            _commitHash,
            reveledBlockDetails[msgSender]
        );
    }

    function reveal(address msgSender, uint _salt) external {
        bool isRevealed = reveledDetails[msgSender];
        require(!isRevealed, "Already revealed");

        uint revealBlock = reveledBlockDetails[msgSender];

        /// Need to identiyf why reavelBlock should be ahead of commit block
        require(block.number >= revealBlock, "Reveal not yet allowed");

        // Recreate the hash to verify
        bytes32 expectedHash = keccak256(abi.encodePacked(msgSender,_salt));
        bytes32 actualHash = commits[msgSender];
        require(expectedHash == actualHash, "Invalid reveal");

        reveledDetails[msgSender] = true;
    }
}
