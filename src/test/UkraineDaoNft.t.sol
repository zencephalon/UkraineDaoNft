// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "ds-test/test.sol";
import "../UkraineDaoNft.sol";

interface CheatCodes {
    function prank(address) external;

    function expectRevert(bytes calldata) external;
}

contract UkraineDaoNftTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    UkraineDaoNft ukraineDaoNft;

    function setUp() public {
        ukraineDaoNft = new UkraineDaoNft();
    }

    function testCantWithdraw() public {
        cheats.expectRevert(bytes("Ownable: caller is not the owner"));
        cheats.prank(address(0));
        ukraineDaoNft.withdraw();
    }
}
