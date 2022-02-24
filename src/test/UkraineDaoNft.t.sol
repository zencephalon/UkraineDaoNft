// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "ds-test/test.sol";
import "../UkraineDaoNft.sol";

interface CheatCodes {
    function prank(address) external;

    function stopPrank() external;

    function deal(address who, uint256 newBalance) external;

    function expectRevert(bytes calldata) external;
}

contract UkraineDaoNftTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    UkraineDaoNft ukraineDaoNft;

    function setUp() public {
        cheats.prank(address(1));
        ukraineDaoNft = new UkraineDaoNft();
    }

    function testCantWithdraw() public {
        cheats.expectRevert(bytes("Ownable: caller is not the owner"));
        cheats.prank(address(0));
        ukraineDaoNft.withdraw(payable(0));
    }

    function testCanWithdraw() public {
        cheats.prank(address(1));
        ukraineDaoNft.withdraw(payable(address(0)));
    }

    function testCanMint() public {
        cheats.deal(address(2), 999999999999999999999999999999);
        cheats.prank(address(2));
        ukraineDaoNft.mint{value: 100000000000000000 * 5}(5);
        assertEq(address(ukraineDaoNft).balance, 100000000000000000 * 5);

        cheats.prank(address(1));
        ukraineDaoNft.withdraw(payable(address(0)));
        assertEq(address(0).balance, 100000000000000000 * 5);
    }
}
