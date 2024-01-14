// SPDX-Licenses-Identifier: MIT;
pragma solidity ^0.8.10;

import { TimelockController } from "@openzeppelin/contracts/governance/TimelockController.sol";

contract TimeLock is TimelockController {

    constructor(uint256 minDelay_, address[] memory proposers, address[] memory executors_) 
    TimelockController(minDelay_, proposers, executors_, msg.sender) {
    }
}