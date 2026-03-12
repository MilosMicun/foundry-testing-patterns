// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {TokenFactory} from "../../src/TokenFactory.sol";
import {Token} from "../../src/Token.sol";

contract TokenFactoryFuzzTest is Test {
    TokenFactory factory;

    function setUp() public {
        factory = new TokenFactory();
    }

    function testFuzzDeployToken(string memory name, string memory symbol, uint256 initialSupply) public {
        address tokenAddr = factory.deployToken(name, symbol, initialSupply);
        Token token = Token(tokenAddr);
        assertEq(factory.tokensLength(), 1);
        assertEq(factory.tokens(0), tokenAddr);
        assertEq(token.name(), name);
        assertEq(token.symbol(), symbol);
        assertEq(token.totalSupply(), initialSupply);
        assertEq(token.balanceOf(address(this)), initialSupply);
    }
}
