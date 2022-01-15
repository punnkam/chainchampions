//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./Champion.sol";

contract Arena is ERC721, ERC721Enumerable, Ownable {
    uint256[] winners; //dynamic size depending on bounty pool
    uint256 gameCount;
    uint256 lastGameBlock;
    bool gameActive;

    uint256 public constant gameLengthBlocks = 420;
    uint256 public constant entryOpenBlocks = 69;
    uint256 public constant delayGameBlocks = 69;

    mapping(uint256 => address) championDepositor; //change to check champion mapping

    // MODIFIERS
    modifier onlyOpenArena() {
        require(entryOpen(), "Invalid action: Arena is not open");
        _;
    }

    modifier onlyNonGame() {
        require(!gameActive, "Invalid action: Game is still active");
        _;
    }

    struct ArenaInfo {
        uint256 gameCount;
        uint256 entryOpenBlock;
        uint256 entryClosedBlock;
        uint256 gameStartBlock;
        uint256 gameEndBlock;
        uint256 numPlayers;
        // uint256 prizePool;
        bool entryActive;
    }

    constructor() {
        console.log("Deploying Arena Contract at: ", address(this));
        greeting = _greeting;
    }

    function arenaInfo() external view returns (ArenaInfo memory info) {
        info.gameCount = gameCount;
        info.entryClosedBlock = entryClosedBlock();
        info.entryOpenBlock = entryOpenBlock();
        info.gameStartBlock = entryClosedBlock();
        info.gameEndBlock = lastGameBlock;
        info.numPlayers = balanceOf(address(this)); // info.prizePool = address(this).balance;
        info.entryActive = entryOpen();
        info.gameActive = gameActive;
    }

    /* 
        ACCESSORS
    */

    function entryOpen() public view returns (bool) {
        return
            block.number > entryOpenBlock && block.number < entryClosedBlock();
    }

    function entryOpenBlock() public view returns (uint256) {
        return lastGameBlock + delayGameBlocks;
    }

    function entryClosedBlock() public view returns (uint256) {
        return entryOpenBlock() + entryOpenBlocks;
    }

    // Return array of msg.senders champions
    function myChampions() external view returns (uint256[] memory) {
        return ownerChampions(msg.sender);
    }

    // Return array of _owner's champions
    function ownerChampions(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 total = balanceOf(holdingAddress);
        uint256[] memory champions = new uint256[](total);

        uint256 index = 0;
        for (uint256 i = 0; i < total; i++) {
            uint256 id = tokenOfOwnerByIndex(holdingAddress, i);

            if (championDepositor[id] == _owner) {
                //change to check champion mapping
                champions[index++] = id;
            }
        }
        return champions;
    }

    /* 
        OWNER METHODS (called by script)
    */
    function openEntry() external onlyOwner {}

    function endEntry() external onlyOwner {}

    function startGame() external onlyOwner {}

    function endGame() external onlyOwner {
        // _crownChamps()
        // Change state vars
        // Clear state (not championDepositor)
        // Send tax to controller
    }

    /* 
        USER METHODS 
    */
    function joinArena(uint256 _tokenId) external onlyOpenArena {
        _joinArena(_tokenId);
    }

    function multiJoinArena(uint256[] memory _tokenIds) external onlyOpenArena {
        require(
            _tokenIds.length <= 3,
            "The maximum number of champs in The Arena is 3"
        );
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            _joinArena(_tokenIds[i]);
        }
    }

    function leaveArena(uint256 _tokenId) external onlyNonGame {
        require(
            championDepositor[_tokenId] == msg.sender, //change to check champion mapping
            "Invalid tokenId, not your champ"
        );

        // Add a call to Champion to change metadata

        // Clear state
        delete championDepositor[_tokenId]; //change to check champion mapping

        // Check if champion is winner and return bounty if so
        for (uint256 i = 0; i < winners.length; i++) {
            if (winners[i] == _tokenId) {
                payable(msg.sender).transfer(_taxedBounty());
            }
        }

        // Return champion
        _transfer(address(this), msg.sender, _tokenId);
    }

    /* 
        INTERNAL METHODS
    */
    function _crownChamps() internal {
        // Probabilistic calculation and put tokenIds in champions
    }

    function _joinArena(uint256 _tokenId) {
        // Transfer bounty (check that it is 0.1e)
        // Toggle attribute of champion contract
    }

    function _taxedBounty() internal returns (uint256) {
        return address(this).balance - _twoPercent(address(this).balance);
    }

    function getTax() internal returns (uint256) {
        return _twoPercent(address(this).balance);
    }

    function _twoPercent(uint256 _value) internal returns (uint256) {
        uint256 roundValue = SafeMath.ceil(_value, 100);
        uint256 twoPercent = SafeMath.div(SafeMath.mul(roundValue, 200), 10000);
        return twoPercent;
    }

    /*
        MISC METHODS
    */
}
