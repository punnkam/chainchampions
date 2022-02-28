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

    uint256 lastMatchTime; // arena last game block
    uint256 lobbyLengthTime; // lobby blocktime
    uint256 matchLengthTime; // match blocktime
    uint256 matchCounter; // game counter --> use chainlink keepers
    uint256 winner; // tokenId of winning Champion
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

    /**
     * @dev Initializes the arena contract and initially
     *      sets the contract arena and the contract state as inactive
     * @param _arenaActive is the active state of the arena
     * @param _contractActive is the active state of the contract
     */
    constructor(uint256 _lobbyLengthTime, uint256 _matchLengthTime, bool _arenaActive, bool _contractActive) {
        lobbyLengthTime = _lobbyLengthTime;
        matchLengthTime = _matchLengthTime;
        arenaActive = _arenaActive;
        contractActive = _contractActive;
    }

    /*******************
    *** VIEW METHODS ***  
    *******************/

    /**
     * @dev Returns the arena information.
     */
    function getArenaDetails() public view returns() {

    }

    /**
     * @dev Returns the active state of a tokenId 
     */
    function getTokenActive(uint256 _tokenId) public view returns(bool) {
        return tokenIsActive[_tokenId];
    }
    
    /**
     * @dev Returns the active state of the arena
     */
    function getArenaActive() public view returns(bool) {
        return arenaActive;
    }

    /**
     * @dev Returns the remaining match time
     */
    function matchTimeLeft() public view returns(uint256) {
        return lastMatchTime + matchLengthTime - block.timestamp;
    }

    /**
     * @dev Returns the winner (of previous match)
     */
    function getWinner() public view returns(uint256) {
        return winner;
    }

    /*******************
    *** USER METHODS ***  
    *******************/


    /*******************
    *** ADMIN METHODS **  
    *******************/


    /*******************
    * INTERNAL METHODS *  
    *******************/

    /*******************
    * OVERRIDE METHODS *  
    *******************/
    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }

}
