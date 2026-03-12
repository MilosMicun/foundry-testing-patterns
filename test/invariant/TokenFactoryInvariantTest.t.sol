// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {TokenFactory} from "../../src/TokenFactory.sol";
import {TokenFactoryHandler} from "./TokenFactoryHandler.t.sol";

contract TokenFactoryInvariantTest is StdInvariant, Test {
    TokenFactory factory;
    TokenFactoryHandler handler;

    function setUp() public {
        factory = new TokenFactory();
        handler = new TokenFactoryHandler(factory);
        targetContract(address(handler));
    }

    function invariant_registryMatchesDeployments() public view {
        assertEq(factory.tokensLength(), handler.deployments());
    }

    function invariant_registryHasNoZeroAddress() public view {
        uint256 len = factory.tokensLength();
        for (uint256 i = 0; i < len; i++) {
            address token = factory.tokens(i);
            assertTrue(token != address(0));
        }
    }

    function invariant_registryContainsContracts() public view {
        uint256 len = factory.tokensLength();
        for (uint256 i = 0; i < len; i++) {
            address token = factory.tokens(i);
            assertTrue(token.code.length > 0);
        }
    }
}
