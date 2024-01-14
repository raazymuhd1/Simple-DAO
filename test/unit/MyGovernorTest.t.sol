// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import { Test, console } from "forge-std/Test.sol";
import { MyGovernor } from "../../src/MyGovernor.sol";
import { TimeLock } from "../../src/TimeLock.sol";
import { Box } from "../../src/Box.sol";
import { GovernanceToken } from "../../src/GovernanceToken.sol";

contract GovernorTest is Test {
    MyGovernor governor;
    GovernanceToken govtToken;
    TimeLock timelock;
    Box box;

    address private USER = makeAddr("USER");
    uint256 private constant MIN_DELAY = 3600; // 1 hour

    address[] proposers;
    address[] executors;

    function setUp() public {
        govtToken = new GovernanceToken();

        govtToken.mint(USER, 1000_000);

        vm.startPrank(USER);
        // move/delegate a voting power to specify address
        govtToken.delegate(USER);
        timelock = new TimeLock(MIN_DELAY, proposers, executors);
        governor = new MyGovernor(govtToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor)); // only governor can propose a proposal
        timelock.grantRole(executorRole, address(0)); // anyone can execute the proposal
        timelock.revokeRole(executorRole, USER); // revoke admin role from the current admin of the timelock, and now the timelock owned by the DAO(governor);

        vm.stopPrank();

        box = new Box();
        box.transferOwnership(address(timelock)); // transfer ownership to a timelock
        // now timelock owns the dao, and dao owns the timelock

    }

    function test_updateBoxWithoutGovernor() public {
        vm.expectRevert();
        box.storeNumber(10);
    }

    // function tset

}
