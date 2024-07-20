// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract PartialRefund is ERC20Capped {
    address private contractOwner;
    /// Error for not sending 1 ether for minting 1000 tokens.
    error MintTokenPreConditionError(string message);
    /// If user dont have enogh token for transaction.
    error NotSufficientTokenError(string message);
    /// Sell back tranfer error.
    error SellbackTokenTransferError(address seller);
    /// Sell back not enough money error.
    error NotEnoughEtherToBuyBack(string message);

    modifier onlyOwner() {
        if (msg.sender != contractOwner) {
            revert();
        }
        _;
    }

    constructor(
        uint256 cap
    ) ERC20("GodToken", "GT") ERC20Capped(cap * 10 ** decimals()) {
        contractOwner = msg.sender;
    }

    function buyToken() external payable {
        if (msg.value == 0 ether) {
            revert MintTokenPreConditionError({
                message: "Ether value should not be zero"
            });
        }

        uint tokenCanBeMintedBasedOnEthersSend = msg.value * 1000;
        _mint(msg.sender, tokenCanBeMintedBasedOnEthersSend);
    }

    /// Allows owner to withdraw tokens.
    function withDrawEther() external payable onlyOwner {
        payable(contractOwner).transfer(address(this).balance);
    }

    /// Allows user to sent token to contract and get partial refund.
    /// If contract does not have enough ether then fuction will block the transaction.
    /// tokenToSell: a parameter receives number of token user want to sell back to contract.
    function sellBack(uint tokenToSell) external {
        if (msg.sender == address(0)) {
            revert("Not a valid address");
        }

        uint totalTokens = balanceOf(msg.sender); // tokens

        if (tokenToSell > totalTokens) {
            revert NotSufficientTokenError({
                message: "Do not have sufficient tokens to sellBack"
            });
        }

        uint partialRefundValue = (tokenToSell / 1000) * 0.5 ether;

        if (address(this).balance < partialRefundValue) {
            revert NotEnoughEtherToBuyBack({
                message: "Do not have enough ether for refund"
            });
        }

        /// Does not check allowance, directly transfers
        _transfer(msg.sender, address(this), tokenToSell);

        (bool sent, ) = payable(msg.sender).call{value: partialRefundValue}("");
        if (sent == false) {
            revert SellbackTokenTransferError({seller: msg.sender});
        }
    }
}
