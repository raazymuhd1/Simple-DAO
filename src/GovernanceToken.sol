// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { ERC20Permit } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import { ERC20Votes } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import { Nonces } from "@openzeppelin/contracts/utils/Nonces.sol";

contract GovernanceToken is  ERC20, ERC20Votes, ERC20Permit {
    constructor() ERC20("Governance Token", "GT") ERC20Permit("Governance Token") {}


    function mint(address to_, uint256 amount_) external returns(bool) {
        _mint(to_, amount_ * 1e18);
        return true;
    }

    // The functions below are overrides required by Solidity.

    function _update(address from_, address to_, uint256 amount_)  internal override(ERC20Votes, ERC20) {
        super._update(msg.sender, to_, amount_);
    }

    function nonces(address owner) public view override(ERC20Permit, Nonces) returns(uint256) {
        super.nonces(owner);
    }

    // function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
    //     super._afterTokenTransfer(from, to, amount);
    // }


}