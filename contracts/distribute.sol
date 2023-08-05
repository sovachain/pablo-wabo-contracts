// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenDistributor {
    using SafeERC20 for IERC20;

    address public owner;
    IERC20 public token;
    mapping(address => bool) public claimed;

    event TokensDistributed(address indexed receiver, uint256 amount);

    constructor(address _tokenAddress) {
        owner = msg.sender;
        token = IERC20(_tokenAddress);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    modifier notClaimed() {
        require(!claimed[msg.sender], "You have already claimed tokens");
        _;
    }

    function distributeTokens(uint256 amount) external notClaimed {
        require(amount > 0, "Amount must be greater than zero");
        require(token.balanceOf(address(this)) >= amount, "Insufficient tokens in the contract");

        claimed[msg.sender] = true;
        token.safeTransfer(msg.sender, amount);

        emit TokensDistributed(msg.sender, amount);
    }

    function setOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }
}
