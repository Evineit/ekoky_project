//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EkokyToken is ERC20 { // inherits from ERC20 token standard
    constructor() ERC20("EkokyToken", "ZENIQ") {
        _mint(msg.sender, 1e18 * 1e9); // generate initial tokens
    }
}
