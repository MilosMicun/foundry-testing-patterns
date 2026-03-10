// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Token, ZeroAddress, InsufficientBalance} from "../../src/Token.sol";

contract TokenTest is Test {
    Token token;

    function setUp() public {
        token = new Token(address(this), "TestToken", "TT", 1000);
    }

    function testTransferSuccess() public {
        address bob = address(1);
        token.transfer(bob, 40);
        assertEq(token.balanceOf(address(this)), 960);
        assertEq(token.balanceOf(bob), 40);
        assertEq(token.totalSupply(), 1000);
    }

    function testTransferRevertOnZeroAddress() public {
        vm.expectRevert(ZeroAddress.selector);
        token.transfer(address(0), 40);
    }

    function testTransferRevertOnInsufficientBalance() public {
        address alice = address(2);
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(InsufficientBalance.selector, 0, 40));
        token.transfer(address(1), 40);
    }
}
