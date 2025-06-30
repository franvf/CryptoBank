//SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../../src/CryptoBank.sol";

contract CryptoBankFuzzingTest is Test {
    CryptoBank private cryptoBank;

    address private user1 = address(0x123);

    function setUp() public {
        cryptoBank = new CryptoBank();
        vm.deal(user1, 100 ether);
    }

    function test_canDepositAndWithdraw(
        uint64 amountToDeposit,
        uint64 amountToWithdraw
    ) public {
        vm.startPrank(user1);
        if (amountToDeposit == 0) {
            vm.expectRevert(CryptoBank.CryptoBank__ZeroETH.selector);
            cryptoBank.deposit{value: amountToDeposit}();
            vm.stopPrank();
            return;
        }

        cryptoBank.deposit{value: amountToDeposit}();
        assertEq(cryptoBank.getBalance(), amountToDeposit);

        if (amountToWithdraw > amountToDeposit) {
            bytes memory selector = abi.encodeWithSelector(
                CryptoBank.CryptoBank__InsufficientBalance.selector,
                amountToWithdraw,
                amountToDeposit
            );
            vm.expectRevert(selector);
            cryptoBank.withdraw(amountToWithdraw);
            vm.stopPrank();
            return;
        }

        cryptoBank.withdraw(amountToWithdraw);
        assertEq(cryptoBank.getBalance(), amountToDeposit - amountToWithdraw);
        vm.stopPrank();
    }
}
