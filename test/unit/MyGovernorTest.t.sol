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
    uint256 private constant MIN_DELAY = 3600; // 1 hour ( i hour delay bfore execute the proposal )
    uint256 constant VOTING_DELAY = 1; // 1 block
    uint256 constant VOTING_PERIOD = 50400; // 1 week

    address[] proposers;
    address[] executors;

    address[] targets; // contract target
    uint256[] values;
    bytes[] calldatas; // bytes of function selector

    function setUp() public {
        vm.deal(USER, 10 ether);
        govtToken = new GovernanceToken();
        govtToken.mint(USER, 1000_000);

        vm.startPrank(USER);
        // move/delegate a voting power to specify address
        govtToken.delegate(USER);
        timelock = new TimeLock(MIN_DELAY, proposers, executors);
        governor = new MyGovernor(govtToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor)); // only governor can propose a proposal
        timelock.grantRole(executorRole, address(0)); // anyone can execute the proposal
        timelock.revokeRole(executorRole, USER); // revoke admin role from the current admin of the timelock, and now the timelock owned by the DAO(governor);

        vm.stopPrank();

        box = new Box(USER);
        box.transferOwnership(address(timelock)); // transfer ownership to a timelock
        // now timelock owns the dao, and dao owns the timelock

    }

    function test_updateBoxWithoutGovernor() public {
        vm.expectRevert();
        box.storeNumber(10);
    }

    function test_UpdateBoxByGovernance() public {
         uint256 storeNumber = 100;
         string memory description = "just wanna store number";
         bytes memory functionToCall = abi.encodeWithSignature("storeNumber(uint256)", storeNumber);

         values.push(0); // we dont wanna send any eth
         targets.push(address(box)); // 
         calldatas.push(functionToCall);

         vm.startPrank(USER);

        //  propose a proposal by governor
        uint256 proposalId = governor.propose(targets, values, calldatas, description);
        console.log("proposal state", uint256(governor.state(proposalId))); // to check proposal state

        vm.warp(block.timestamp + VOTING_DELAY + 1); // to pass a voting delay so that proposal become active
        vm.roll(block.number + VOTING_DELAY + 1);

        console.log("proposal state", uint256(governor.state(proposalId))); 

        string memory reason = "i love this number";
        uint8 voteWay = 1; // vote FOR

        governor.castVoteWithReason(proposalId, voteWay, reason);

        vm.warp(block.timestamp + VOTING_PERIOD + 1); // to pass a voting period so that this proposal can be queue
         vm.roll(block.number + VOTING_PERIOD + 1);

         bytes32 descriptionHash = keccak256(abi.encodePacked(description));
         governor.queue(targets, values, calldatas, descriptionHash);

         vm.warp(block.timestamp + MIN_DELAY + 1); // to pass a min delay so that this proposal can be execute
         vm.roll(block.number + MIN_DELAY + 1);

        //  ITS TIME TO EXECUTE THE PROPOSAL AFTER GETS QUEUED UP
        governor.execute(targets, values, calldatas, descriptionHash);

        vm.stopPrank();

        console.log(box.getStoreNumber());
        assert(box.getStoreNumber(), storeNumber);
    }

}
