// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {TokenFactory} from "../../src/TokenFactory.sol";
import {Token} from "../../src/Token.sol";

contract TokenFactoryIntegrationTest is Test {
    TokenFactory factory;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address carol = makeAddr("carol");

    function setUp() public {
        factory = new TokenFactory();
    }

    function testFactoryDeployToken() public {
        vm.prank(alice);
        address tokenA = factory.deployToken("TokenA", "TKA", 1000);
        Token token = Token(tokenA);
        assertEq(factory.tokensLength(), 1);
        assertEq(factory.tokens(0), tokenA);
        assertTrue(tokenA.code.length > 0);
        assertEq(token.name(), "TokenA");
        assertEq(token.symbol(), "TKA");
        assertEq(token.balanceOf(alice), 1000);
        assertEq(token.totalSupply(), 1000);
    }

    function testFactoryDeploysUniqueTokenAddresses() public {
        vm.prank(alice);
        address tokenA = factory.deployToken("TokenA", "TKA", 1000);
        vm.prank(bob);
        address tokenB = factory.deployToken("TokenB", "TKB", 1000);
        assertEq(factory.tokensLength(), 2);
        assertEq(factory.tokens(0), tokenA);
        assertEq(factory.tokens(1), tokenB);
        assertTrue(tokenA != tokenB);
    }

    function testDeployedTokensKeepIndependentState() public {
        vm.prank(alice);
        address tokenA = factory.deployToken("TokenA", "TKA", 1000);
        vm.prank(bob);
        address tokenB = factory.deployToken("TokenB", "TKB", 2000);
        Token token1 = Token(tokenA);
        Token token2 = Token(tokenB);
        assertEq(token1.name(), "TokenA");
        assertEq(token2.name(), "TokenB");
        assertEq(token1.symbol(), "TKA");
        assertEq(token2.symbol(), "TKB");
        assertEq(token1.balanceOf(alice), 1000);
        assertEq(token2.balanceOf(bob), 2000);
        assertEq(token1.totalSupply(), 1000);
        assertEq(token2.totalSupply(), 2000);
    }
}
