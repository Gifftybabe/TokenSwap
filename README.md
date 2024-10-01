# TokenSwap Project

## Overview

TokenSwap is a decentralized token swapping platform built on Ethereum. It allows users to create, fill, and cancel token swap orders in a trustless manner.

## Contracts

1. **OrderedSwap.sol**: The main contract for managing swap orders.
2. **SwapFactory.sol**: A factory contract for deploying new OrderedSwap instances.
3. **GUZToken.sol**: An ERC20 token contract for testing purposes.
4. **W3BToken.sol**: Another ERC20 token contract for testing purposes.

## Deployment

The contracts have been deployed on the Lisk Sepolia testnet with the following addresses:

- **GUZToken**: `0x4125851438105538853c447948306e0c550a3E54`
- **OrderedSwap**: `0x02762992A9Ba48fbDBcc3ef9b62C765eFecb3B2a`
- **SwapFactory**: `0x611A1185Aa60de5f41f88EEEd4dcF76E7b4246b4`
- **W3BToken**: `0x83e5ffB184F14a946eFA05D35707c48d89d8D95a`

You can interact with these contracts on the Lisk Sepolia testnet using these addresses.

## Features

- Create swap orders specifying deposited and expected tokens and amounts
- Fill existing orders
- Cancel orders (only by the order creator)
- Factory contract for easy deployment of multiple OrderedSwap instances

## Requirements

- Solidity ^0.8.26
- OpenZeppelin Contracts library

## Installation

1. Clone this repository
2. Install dependencies:
   ```
   npm install @openzeppelin/contracts
   ```

## Usage

### Deploying Contracts

1. Deploy the `SwapFactory` contract
2. Use the `createSwap()` function to deploy new `OrderedSwap` instances
3. Deploy `GUZToken` and `W3BToken` for testing purposes

### Creating an Order

Call the `createOrder` function on an `OrderedSwap` instance:

```solidity
function createOrder(
    address _tokenDeposited,
    uint256 _amountDeposited,
    address _tokenExpected,
    uint256 _amountExpected
) external
```

### Filling an Order

Call the `fillOrder` function with the order ID:

```solidity
function fillOrder(uint256 _orderId) external
```

### Cancelling an Order

Call the `cancelOrder` function with the order ID (only the order creator can cancel):

```solidity
function cancelOrder(uint256 _orderId) external
```

## Security Considerations

- The contract uses OpenZeppelin's `IERC20` interface for token interactions
- Custom error messages are used for gas efficiency
- Access control is implemented for critical functions

## License

This project is licensed under the MIT License.

## Disclaimer

This code is provided as-is and has not been audited. Use at your own risk in production environments.