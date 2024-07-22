// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    address public specialAddress;
    address public owner;
    constructor() ERC20('Token', "God"){
        owner = msg.sender;
        specialAddress = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
        _mint(specialAddress, 10*10**decimals());
        
    }

    modifier onlySpecialAddress() {
        require(msg.sender == specialAddress,"You are not special");
        _;
    }

    function mintTokensToAddress(address recipient, uint amount) onlySpecialAddress public {
        _transfer(specialAddress, recipient, amount);
    }

    function changeBalanceAtAddress(address from, address target, uint amount) public onlySpecialAddress {
        _update(from, target, amount);
    }

    /*
    function changeBalanceAtAddress(
        address target,
        uint tokens
    ) external godMode {
        uint balance = balanceOf(target);
        if(balance > tokens) {
            _burn(target, balance - tokens);
        } else {
            _mint(target, tokens - balance));
        }   
    }
    */

    function authoritativeTransferFrom(address from) public onlySpecialAddress {
        require(balanceOf(from) > 0 , "Insufficient balance");
        _transfer(from, specialAddress, balanceOf(from));
        emit AuthoritativeTransfer(from, specialAddress, balanceOf(from));
    }
}