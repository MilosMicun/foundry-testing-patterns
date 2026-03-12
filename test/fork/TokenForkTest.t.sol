// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";

contract TokenForkTest is Test {
    IERC20 token;

    address constant TOKEN = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    uint256 constant FORK_BLOCK = 19000000;
    // Known USDC holder for the pinned fork scenario
    address constant USDC_WHALE = 0x55FE002aefF02F77364de339a1292923A15844B8;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"), FORK_BLOCK);
        token = IERC20(TOKEN);
    }

    function testForkHasCodeAtTokenAddress() public view {
        assertGt(TOKEN.code.length, 0);
    }

    function testForkCanCallBalanceOf() public view {
        token.balanceOf(address(this));
    }

    function testForkWhaleHasBalance() public view {
        assertGt(token.balanceOf(USDC_WHALE), 0);
    }

    function testForkCanReadTotalSupply() public view {
        assertGt(token.totalSupply(), 0);
    }

    function testForkCanReadAllowance() public view {
        uint256 allowance = token.allowance(alice, bob);
        assertEq(allowance, 0);
    }

    function testForkApproveSetsAllowance() public {
        vm.prank(alice);
        bool ok = token.approve(bob, 100);
        assertTrue(ok);
        assertEq(token.allowance(alice, bob), 100);
    }

    function testForkTransferFromFlow() public {
        deal(address(token), alice, 100);

        vm.prank(alice);
        token.approve(bob, 100);

        vm.prank(bob);
        token.transferFrom(alice, bob, 100);

        assertEq(token.balanceOf(bob), 100);
        assertEq(token.allowance(alice, bob), 0);
    }
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    function totalSupply() external view returns (uint256);
}
