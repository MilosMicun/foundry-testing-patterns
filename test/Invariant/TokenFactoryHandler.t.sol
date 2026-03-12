// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {TokenFactory} from "../../src/TokenFactory.sol";

contract TokenFactoryHandler is Test {
    TokenFactory factory;
    uint256 public deployments;

    constructor(TokenFactory _factory) {
        factory = _factory;
    }

    function deployToken(string memory name, string memory symbol, uint256 initialSupply) public {
        if (deployments >= 20) return;
        factory.deployToken(name, symbol, initialSupply);
        deployments++;
    }
}
