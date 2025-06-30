//SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../../src/CryptoBank.sol";

contract CryptoBankUnitTest is Test {
    CryptoBank private cryptoBank;

    address private user1 = address(0x123);
    address private user2 = address(0x456);

    function setUp() public {
        cryptoBank = new CryptoBank();
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function test_canDeposit() public {
        vm.startPrank(user1);
        uint256 depositAmount = 1 ether;
        cryptoBank.deposit{value: depositAmount}();
        assertEq(cryptoBank.getBalance(), depositAmount);
        vm.stopPrank();
    }

    function test_cannotDepositZeroETH() public {
        vm.startPrank(user1);
        vm.expectRevert(CryptoBank.CryptoBank__ZeroETH.selector);
        cryptoBank.deposit{value: 0}();
        vm.stopPrank();
    }

    function test_canWithdraw() public {
        vm.startPrank(user1);
        uint256 depositAmount = 1 ether;
        cryptoBank.deposit{value: depositAmount}();
        cryptoBank.withdraw(depositAmount);
        assertEq(cryptoBank.getBalance(), 0);
        vm.stopPrank();
    }

    function test_cannotWithdrawMoreETHThanDeposited() public {
        vm.startPrank(user1);
        bytes memory selector = abi.encodeWithSelector(
            CryptoBank.CryptoBank__InsufficientBalance.selector,
            1 ether,
            0 ether
        );
        vm.expectRevert(selector);
        cryptoBank.withdraw(1 ether);
        vm.stopPrank();
    }
}
