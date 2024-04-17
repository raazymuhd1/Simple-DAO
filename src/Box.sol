// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract Box is Ownable {
    uint256 private s_number;

    event NumberChanged(uint256 newNumber);

    constructor(address initialOwner_) Ownable(initialOwner_) {
        
    }

    function storeNumber(uint256 newNumber) external returns(uint256) {
        s_number += newNumber;
        emit NumberChanged(newNumber);
        return s_number;
    }

    function getStoreNumber() external view returns(uint num) {
        num = s_number;
    }
}