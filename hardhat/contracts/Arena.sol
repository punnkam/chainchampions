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
    uint8 bountySize; // amount needed to enter Arena 
    bool arenaActive; // arena active bool
    bool gameActive; // game active bool
    bool internal locked; // reentrancy guard variable
    uint256[] tokens; // id of all champions currently in the Arena for game end loop
    mapping(uint256 => address) tokenToDepositor; // depositor mapping
    mapping(uint256 => bool) tokenIsActive; // isActive mapping
    mapping(address => uint256) withdrawableBounty; // withdraw balance mapping

    Champion champion; // Reference to Champion contract

    /*******************
    ****** EVENTS ******  
    *******************/
    event EnteredArena(uint256 tokenId, address owner);
    event ExitedArena(uint256 tokenId, address owner);
    event WinnerSelected(uint256 tokenId, address owner, uint256 winnings);
    

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

    modifier reentrancyGuard() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    /**
     * @dev Initializes the arena contract and initially
     *      sets the contract arena and the contract state as inactive
     * @param _lobbyLengthTime length of lobby in time units
     * @param _matchLengthTime length of match in time units
     * @param _bountySize the amount needed to enter the arena
     * @param _arenaActive is the active state of the arena
     * @param _gameActive is the active state of the contract
     */
    constructor(uint256 _lobbyLengthTime, uint256 _matchLengthTime, uint8 _bountySize, bool _arenaActive, bool _gameActive) {
        lobbyLengthTime = _lobbyLengthTime;
        matchLengthTime = _matchLengthTime;
        arenaActive = _arenaActive;
        gameActive = _gameActive;
        bountySize = _bountySize;
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

    /**
     * @dev Returns the prize pool (amount in the contract)
     */
    function getPrize() public view returns(uint256) {
        return address(this).balance;
    }

    /*******************
    *** USER METHODS ***  
    *******************/
    
    /**
     * @dev Allows owner of a Champion to enter the Champion into the Arena.
     * @param _tokenId id of the ERC721 asset (Champion)
     */
    function enterArena(uint256 _tokenId) external payable onlyArenaActive {
        require(msg.value >= bountySize, "Submitted bounty is not large enough to enter the Arena");
        require(msg.sender == champion.ownerOf(_tokenId), "You do not own this Champion");
        tokens.push(_tokenId);

        _enterArena(_tokenId);
        emit EnteredArena(_tokenId, msg.sender);
    }

    /**
     * @dev Allows owner of a Champion to exit the Champion from the Arena.
     * @param _tokenId id of the ERC721 asset (Champion)
     */
    function exitArena(uint256 _tokenId) external onlyArenaActive gameInactive {
        require(address(this) == champion.ownerOf(_tokenId), "This Champion is not in the contract");
        require(msg.sender == tokenToDepositor[_tokenId], "You don't own this Champion");

        _exitArena(_tokenId);
        emit ExitedArena(_tokenId, msg.sender);
    }

    /**
     * @dev Allows owner of a Champion that is deposited in the Arena to play again
     * @param _tokenId id of the ERC721 asset (Champion)
     */
    function replay(uint256 _tokenId) external payable onlyArenaActive gameInactive {
        require(address(this) == champion.ownerOf(_tokenId), "This Champion is not in the contract");
        require(msg.sender == tokenToDepositor[_tokenId], "You don't own this Champion");
        require(msg.value >= bountySize, "Submitted bounty is not large enough to replay the game");

        tokenIsActive[_tokenId] = true;
    }

    /**
     * @dev Allows players that own a tokenId that won to withdraw their bounty share
     */
    function withdrawBounty() external reentrancyGuard {
        require(withdrawableBounty[msg.sender] > 0, "No bounty to withdraw");
        uint256 amount = withdrawableBounty[msg.sender];
        withdrawableBounty[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: amount}("");
        if(!sent) withdrawableBounty[msg.sender] = amount;
    }


    /*******************
    *** ADMIN METHODS **  
    *******************/


    /**
     * @dev Starts the game, only called by owner
     */
    function startGame() external onlyOwner {
        require(block.timestamp > lastMatchTime + lobbyLengthTime, "We are still in the Lobby Phase");
        gameActive = true;
    }

    /**
     * @dev Ends the game, only called by owner
     */
    function endGame() external onlyOwner onlyGameActive {
        require(block.timestamp > lastMatchTime + lobbyLengthTime + matchLengthTime, "The game should not end yet");
        gameActive = false;

        winner = _crownWinner();
        lastMatchTime = block.timestamp;

        for(uint256 i=0; i<tokens.length; i++) 
            tokenIsActive[i] = false;

        delete tokens;
    }

    /**
     * @dev Points the reference variable to the champion contract, only called by owner
     */
    function setChampion(address _contract) external onlyOwner {
        champion = Champion(_contract);
    }


    /*******************
    * INTERNAL METHODS *  
    *******************/
    
    /**
     * @dev Called by user to enter champion into arena
     * @param _tokenId id of the Champion
     */
    function _enterArena(uint256 _tokenId) internal onlyArenaActive {
        champion.transferFrom(msg.sender, address(this), _tokenId);
        tokenToDepositor[_tokenId] = msg.sender;
        tokenIsActive[_tokenId] = true;
    }

    /**
     * @dev Called by user to exit champion from arena
     * @param _tokenId id of the Champion
     */
    function _exitArena(uint256 _tokenId) internal onlyArenaActive {
        champion.transferFrom(address(this) , msg.sender, _tokenId);
        delete tokenToDepositor[_tokenId];
        tokenIsActive[_tokenId] = false;
    }


    /**
     * @dev Determines the winner of the current game using a random number generated
     *      by a keccak hash. In prod, we'll use Chainlink VRF to generate the random
     *      number to prevent determinism exploits.
     */
    function _crownWinner() internal gameInactive returns(uint256) {
        uint256 rand = _random(0, champion.balanceOf(address(this)));
        uint256 winningChamp = champion.tokenByIndex(rand);
        while(!tokenIsActive[winningChamp]) {
            rand = _random(0, champion.balanceOf(address(this)));
            winningChamp = champion.tokenByIndex(rand);
        }
        address owner = champion.ownerOf(winningChamp);
        
        withdrawableBounty[owner] += _getTaxedBounty();

        // loop through tokenIsActive and set all to false
        emit WinnerSelected(winningChamp, owner, _getTaxedBounty());
        return winningChamp;
    }

    /**
     * @dev Generates a random number using keccak256() hash function
     * @param start starting number
     * @param end ending number
     */
    function _random(uint256 start, uint256 end) internal view returns (uint256) {
        uint256 randomNumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.difficulty))
        ) % (end - start);
        return randomNumber + start;
    }

    /**
     * @dev Returns the taxed bounty amount
     */
    function _getTaxedBounty() internal view returns (uint256) {
        return address(this).balance - address(this).balance/100 * 2;
    }

    /*******************
    * OVERRIDE METHODS *  
    *******************/
    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }

}
