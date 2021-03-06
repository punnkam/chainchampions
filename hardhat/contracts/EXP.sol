// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EXP is ERC20, Ownable {
    // a mapping from an address to whether or not it can mint / burn
    mapping(address => bool) controllers;
    uint256 maxSupply; // maximum token supply

    constructor(uint256 _maxSupply) ERC20("EXP", "EXP") {
        maxSupply = _maxSupply;
    }

    /**
     * mints $EXP to a recipient
     * @param to the recipient of the $EXP
     * @param amount the amount of $EXP to mint
     */
    function mint(address to, uint256 amount) external {
        require(controllers[msg.sender], "Only controllers can mint");
        require(totalSupply() <= maxSupply, "Cannot mint more than maxSupply");
        _mint(to, amount);
    }

    /**
     * burns $EXP from a holder
     * @param from the holder of the $EXP
     * @param amount the amount of $EXP to burn
     */
    function burn(address from, uint256 amount) external {
        require(controllers[msg.sender], "Only controllers can burn");
        _burn(from, amount);
    }

    /**
     * enables an address to mint / burn
     * @param controller the address to enable
     */
    function addController(address controller) external onlyOwner {
        controllers[controller] = true;
    }

    /**
     * disables an address from minting / burning
     * @param controller the address to disbale
     */
    function removeController(address controller) external onlyOwner {
        controllers[controller] = false;
    }
}
