// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Token} from "./Token.sol";

contract TokenFactory {
    address[] public tokens;

    event TokenDeployed(address indexed token, address indexed owner, string name, string symbol);

    function deployToken(string memory _name, string memory _symbol, uint256 initialSupply) external returns (address) {
        Token token = new Token(msg.sender, _name, _symbol, initialSupply);
        tokens.push(address(token));
        emit TokenDeployed(address(token), msg.sender, _name, _symbol);
        return address(token);
    }

    function tokensLength() external view returns (uint256) {
        return tokens.length;
    }
}
