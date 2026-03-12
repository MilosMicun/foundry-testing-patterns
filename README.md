# Foundry Testing Patterns

![Tests](https://github.com/MilosMicun/foundry-testing-patterns/actions/workflows/test.yml/badge.svg)

A Solidity project demonstrating **professional smart contract testing strategies using Foundry**.

This repository focuses on **testing architecture and methodology**, not protocol complexity.

The goal is to show how protocol engineers verify smart contract systems using multiple testing layers:

- Unit testing
- Integration testing
- Fork testing (mainnet state)
- Fuzz testing
- Invariant testing

These techniques are widely used in **DeFi protocols and production smart contract systems**.

---

# Project Overview

The system contains two simple contracts designed to demonstrate testing patterns.

## Token.sol

A minimal ERC20-style token used for testing.

### Features

- balance tracking
- transfer logic
- immutable metadata
- custom errors

### Solidity highlight

```solidity
mapping(address => uint256) public balanceOf;
uint256 public totalSupply;

function transfer(address to, uint256 amount) external returns (bool) {
    if (to == address(0)) revert ZeroAddress();

    uint256 senderBalance = balanceOf[msg.sender];
    if (senderBalance < amount) revert InsufficientBalance(senderBalance, amount);

    balanceOf[msg.sender] = senderBalance - amount;
    balanceOf[to] += amount;

    emit Transfer(msg.sender, to, amount);
    return true;
}
TokenFactory.sol

A factory contract responsible for deploying token instances and tracking them in a registry.

Responsibilities

deploy new tokens

maintain registry of deployments

emit deployment events

Solidity highlight
function deployToken(
    string memory _name,
    string memory _symbol,
    uint256 initialSupply
) external returns (address) {
    Token token = new Token(msg.sender, _name, _symbol, initialSupply);

    tokens.push(address(token));

    emit TokenDeployed(address(token), msg.sender, _name, _symbol);

    return address(token);
}
Testing Strategies

This repository demonstrates five different testing approaches used in professional Solidity development.

Unit Testing

Unit tests verify the behavior of individual functions.

Example checks

transfer updates balances

zero address transfers revert

insufficient balance reverts

Location
test/unit/
Example
TokenTest.t.sol
Solidity highlight
function testTransferSuccess() public {
    address bob = address(1);

    token.transfer(bob, 40);

    assertEq(token.balanceOf(address(this)), 960);
    assertEq(token.balanceOf(bob), 40);
}
Integration Testing

Integration tests verify interactions between contracts.

Here we test the interaction between:

TokenFactory

Token instances deployed by the factory

Example checks

token deployment

registry updates

token independence

Location
test/integration/

Example file:

TokenFactoryIntegrationTest.t.sol
Fork Testing

Fork tests interact with real mainnet state.

Foundry creates a local fork of Ethereum mainnet allowing interaction with deployed contracts.

Example checks

reading ERC20 balances

allowance queries

approve → transferFrom flows

Solidity highlight
vm.createSelectFork(vm.envString("MAINNET_RPC_URL"), FORK_BLOCK);

token = IERC20(TOKEN);
Location
test/fork/

Example file:

TokenForkTest.t.sol
Fuzz Testing

Fuzz tests verify contract behavior across randomized input values.

Foundry automatically generates random parameters.

Example fuzz target
function testFuzzDeployToken(
    string memory name,
    string memory symbol,
    uint256 initialSupply
) public
What is tested

registry updates correctly

metadata matches input

initial supply is assigned properly

Location
test/invariant/TokenFactoryFuzzTest.t.sol
Invariant Testing

Invariant testing verifies system-level properties that must always remain true.

Instead of testing single calls, Foundry generates random sequences of actions.

Handler Pattern

The handler defines actions that the invariant engine may execute.

Example action:

function deployToken(
    string memory name,
    string memory symbol,
    uint256 initialSupply
) public

Location:

TokenFactoryHandler.t.sol
Invariants Verified
Registry length matches deployments
factory.tokensLength() == handler.deployments()

Ensures the factory registry remains consistent.

Registry contains no zero addresses
tokens[i] != address(0)

Prevents invalid registry entries.

Registry entries contain deployed contracts
tokens[i].code.length > 0

Ensures registry entries reference deployed contracts.

Location:

TokenFactoryInvariantTest.t.sol
Project Structure
src/
 ├─ Token.sol
 └─ TokenFactory.sol

test/
 ├─ unit/
 │   └─ TokenTest.t.sol
 │
 ├─ integration/
 │   └─ TokenFactoryIntegrationTest.t.sol
 │
 ├─ fork/
 │   └─ TokenForkTest.t.sol
 │
 └─ invariant/
     ├─ TokenFactoryFuzzTest.t.sol
     ├─ TokenFactoryHandler.t.sol
     └─ TokenFactoryInvariantTest.t.sol
Running Tests

Install Foundry:

curl -L https://foundry.paradigm.xyz | bash
foundryup

Build the project:

forge build

Run all tests:

forge test

Verbose test output:

forge test -vv

Run invariant tests only:

forge test --match-path test/invariant

Run fork tests:

forge test --match-path test/fork
Development Workflow

Typical development workflow used in this repository:

Implement contract logic

Write unit tests

Add integration tests

Validate behavior using fork tests

Add fuzz tests for random inputs

Define system invariants

Run full test suite before committing

Example commands:

forge clean
forge build
forge test -vv
forge fmt

This workflow mirrors testing pipelines used in professional Solidity development.

Security Mindset

Smart contract systems require multiple layers of verification.

This repository demonstrates techniques used in real protocol development:

deterministic unit tests

contract interaction testing

mainnet fork validation

fuzz testing for unexpected inputs

invariant testing for system-level guarantees

Invariant testing is especially important in DeFi systems where complex interactions must preserve critical properties regardless of execution order.

Author

Built as part of a structured path toward protocol engineering and DeFi development using Solidity and Foundry.