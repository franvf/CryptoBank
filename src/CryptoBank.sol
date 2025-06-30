//SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

contract CryptoBank {
    //mappings
    mapping(address => uint256) private userBalance;

    //events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    //errors
    error CryptoBank__ZeroETH();
    error CryptoBank__InsufficientBalance(uint256 requested, uint256 available);
    error CryptoBank__TransferFailed();

    //modifiers
    modifier zeroETH() {
        if (msg.value <= 0) {
            revert CryptoBank__ZeroETH();
        }
        _;
    }

    modifier insufficientBalance(uint256 amount) {
        if (userBalance[msg.sender] < amount || userBalance[msg.sender] == 0) {
            revert CryptoBank__InsufficientBalance(
                amount,
                userBalance[msg.sender]
            );
        }
        _;
    }

    //functions
    function deposit() external payable zeroETH {
        userBalance[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(
        uint256 amount
    ) external payable insufficientBalance(amount) {
        userBalance[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");

        if (!success) {
            revert CryptoBank__TransferFailed();
        }

        emit Withdraw(msg.sender, amount);
    }

    function getBalance() external view returns (uint256) {
        return userBalance[msg.sender];
    }
}
