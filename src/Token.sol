// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error InsufficientBalance(uint256 available, uint256 required);
error ZeroAddress();

contract Token {
    mapping(address => uint256) public balanceOf;
    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor(address owner, string memory _name, string memory _symbol, uint256 initialSupply) {
        if (owner == address(0)) revert ZeroAddress();
        name = _name;
        symbol = _symbol;
        balanceOf[owner] = initialSupply;
        totalSupply = initialSupply;
        emit Transfer(address(0), owner, initialSupply);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        if (to == address(0)) revert ZeroAddress();
        uint256 senderBalance = balanceOf[msg.sender];
        if (senderBalance < amount) revert InsufficientBalance(senderBalance, amount);
        balanceOf[msg.sender] = senderBalance - amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
}
