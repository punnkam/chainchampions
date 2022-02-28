//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/**
 * @title Arena
 * @author Punn Kam
 * @dev An implementation of the Arena contract responsible for receiving deposits
 * for the battle royale game. It also performs all calculations for taxation and
 * crowning winners of the battle. The calculations are limited in complexity given
 * the nature of Solidity math; however, computations can be moved off chain in future.
 *
 */

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

import "./Champion.sol";

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
    bool gameActive; // game active bool
    mapping(address => uint256) depositorToToken; // depositor mapping
    mapping(uint256 => bool) tokenIsActive; // isActive mapping

    Champion champion; // Reference to Champion contract

    /*******************
    ****** EVENTS ******  
    *******************/
    

    /*******************
    **** MODIFIERS ****  
    *******************/
    modifier onlyArenaActive {
        require(arenaActive == true, "The Arena is inactive");
        _;
    }

    modifier onlyGameActive {
        require(gameActive == true, "The contract is inactive");
        _;
    }

    modifier gameInactive {
        require(block.timestamp < lastMatchTime + lobbyLengthTime, "There is a game active");
        _;
    }

    /**
     * @dev Initializes the arena contract and initially
     *      sets the contract arena and the contract state as inactive
     * @param _arenaActive is the active state of the arena
     * @param _gameActive is the active state of the contract
     */
    constructor(uint256 _lobbyLengthTime, uint256 _matchLengthTime, bool _arenaActive, bool _gameActive) {
        lobbyLengthTime = _lobbyLengthTime;
        matchLengthTime = _matchLengthTime;
        arenaActive = _arenaActive;
        gameActive = _gameActive;
    }

    /*******************
    *** VIEW METHODS ***  
    *******************/

    /**
     * @dev Returns the arena information.
     */
    function getArenaDetails() public view returns(uint256, uint256, uint256, bool) {
        return (lastMatchTime, matchCounter, winner, arenaActive);
    }

    /**
     * @dev Returns the active state of a tokenId 
     * @param _tokenId id of Champion
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
     * @dev Returns the active state of the game
     */
    function getGameActive() public view returns(bool) {
        return gameActive;
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
    
    function enterArena(uint256[] calldata _tokenIds) external onlyArenaActive {

    }

    function exitArena(uint256[] calldata _tokenIds) external onlyArenaActive {

    }


    /*******************
    *** ADMIN METHODS **  
    *******************/

    function startGame() external onlyOwner {

    }

    function endGame() external onlyOwner onlyGameActive {

    }

    function withdraw() external onlyOwner {

    }


    /*******************
    * INTERNAL METHODS *  
    *******************/
    
    function _enterArena(uint256 _tokenId) internal onlyArenaActive {

    }

    function _exitArena(uint256 _tokenId) internal onlyArenaActive {

    }

    function _crownWinner() internal gameInactive {

    }

    /*******************
    * OVERRIDE METHODS *  
    *******************/
    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }

}
