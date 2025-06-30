# CryptoBank

CryptoBank is a simple smart contract that allows users to deposit and withdraw ETH, keeping track of balances internally. The goal of this project is to serve as a basic introduction to fuzzing testing in Solidity using Foundry.

## Features

- Deposit ETH to the contract
- Withdraw ETH from your account
- Custom error handling
- Event emissions for deposits and withdrawals
- Internal balance mapping per user

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed on your system

### Installation

Clone the repository and install dependencies:

```bash
git clone <your-repo-url>
cd <your-repo-directory>
forge install
```

### Running Tests

You can run the test suite with:

```bash
forge test
```

> This project is intended as a learning exercise, specifically to explore and understand fuzzing testing with Foundry.

## License

This project is licensed under the MIT License.
