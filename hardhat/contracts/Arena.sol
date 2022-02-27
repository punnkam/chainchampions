//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract Arena is IERC721Receiver, Ownable, Pausable {

    /*******************
    ***** STORAGE ******  
    *******************/

    uint256 lastMatchBlock; // arena last game block
    uint256 lobbyLengthBlock; // lobby blocktime
    uint256 matchLengthBlock; // match blocktime
    uint256 matchCounter; // game counter --> use chainlink keepers
    bool arenaActive; // arena active bool
    bool contractActive; // contract active bool
    mapping(address => uint256) depositorToToken; // depositor mapping
    mapping(uint256 => bool) tokenIsActive; // isActive mapping
    

    /*******************
    **** MODIFIERS ****  
    *******************/
    modifier onlyArenaActive {
        require(arenaActive == true, "The Arena is inactive");
        _;
    }

    modifier onlyContractActive {
        require(contractActive == true, "The contract is inactive");
        _;
    }

    modifier gameInactive {
        require(block.number < lastMatchBlock + lobbyLengthBlock, "There is a game active");
        _;
    }

    constructor() {

    }

    /*******************
    *** VIEW METHODS ***  
    *******************/

    /*******************
    *** USER METHODS ***  
    *******************/


    /*******************
    *** ADMIN METHODS **  
    *******************/


    /*******************
    * INTERNAL METHODS *  
    *******************/


    function test() public {
        return 0;
    }
}
