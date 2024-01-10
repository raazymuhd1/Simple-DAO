pragma solidity ^0.8.0;

import { TimelockController } from "@openzeppelin/contracts/governance/TimelockController.sol";

contract TimeLock is TimelockController {

    constructor(uint256 minDelay_, address[] memory proposers, address[] memory executors_, address admin) 
    TimelockController(minDelay_, proposers, executors_, admin) {
    }
}