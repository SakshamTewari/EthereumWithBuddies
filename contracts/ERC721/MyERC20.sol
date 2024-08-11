// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC20 is ERC20{

    event Mint(address indexed _to, uint _amount);
    constructor() ERC20("M20","My20"){
        _mint(msg.sender, 1000e18);
    }

    function mintToken(address _to, uint _amount) public {
        _mint(_to, _amount);
        emit Mint(_to, _amount);
    }

}
