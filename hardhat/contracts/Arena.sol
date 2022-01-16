//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Champion.sol";

contract Arena is Ownable {
    uint256[] winners; //dynamic size depending on bounty pool
    uint256[] champions; // tokenIdds in the pool
    uint256 battleCount;
    uint256 lastBattleBlock;
    bool battleActive;
    bool gameActive;

    uint256 public constant battleLengthBlocks = 4200;
    uint256 public constant entryOpenBlocks = 69;
    uint256 public constant delayBattleBlocks = 69;
    uint256 public constant pricePerEnter = 0.1 ether;

    mapping(address => uint256) pendingWithdrawals;

    //Reference to champion contract
    Champion champContract;

    // MODIFIERS
    modifier onlyOpenArena() {
        require(entryOpen(), "Invalid action: Arena is not open");
        _;
    }

    modifier onlyNonBattle() {
        require(!battleActive, "Invalid action: Battle is still active");
        _;
    }

    modifier onlyGameActive() {
        require(gameActive, "Invalid action: Game is not active");
        _;
    }

    // EVENTS
    event ChampionEntered(address, uint256);
    event BattleEnd(uint256[], uint256, uint256);
    event Received(address, uint256);

    struct ArenaInfo {
        uint256 battleCount;
        uint256 entryOpenBlock;
        uint256 entryClosedBlock;
        uint256 battleStartBlock;
        uint256 battleEndBlock;
        uint256 numPlayers;
        uint256 bounty;
        bool entryActive;
        bool battleActive;
    }

    constructor(address _champContract) {
        console.log("Deploying Arena Contract at: ", address(this));
        champContract = Champion(_champContract);
    }

    function arenaInfo() external view returns (ArenaInfo memory info) {
        info.battleCount = battleCount;
        info.entryClosedBlock = entryClosedBlock();
        info.entryOpenBlock = entryOpenBlock();
        info.battleStartBlock = entryClosedBlock();
        info.battleEndBlock = info.battleStartBlock + battleLengthBlocks;
        info.numPlayers = champContract.getChampionCount(address(this));
        info.entryActive = entryOpen();
        info.battleActive = battleActive;
        info.bounty = getBalance();
    }

    /* 
        ACCESSORS
    */

    function entryOpen() public view returns (bool) {
        return
            block.number > entryOpenBlock() &&
            block.number < entryClosedBlock();
    }

    function entryOpenBlock() public view returns (uint256) {
        return lastBattleBlock + delayBattleBlocks;
    }

    function entryClosedBlock() public view returns (uint256) {
        return entryOpenBlock() + entryOpenBlocks;
    }

    function getWinners() public view returns (uint256[] memory) {
        return winners;
    }

    function getChampions() public view returns (uint256[] memory) {
        return champions;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
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
        uint256 total = champions.length;
        uint256[] memory ownerChamps = new uint256[](total);

        uint256 index = 0;
        for (uint256 i = 0; i < total; i++) {
            if (champContract.getOwner(champions[i]) == _owner) {
                //change to check champion mapping
                ownerChamps[index++] = champions[i];
            }
        }
        return champions;
    }

    /* 
        OWNER METHODS (called by script)
    */
    function ownerWithdraw(uint256 amount) public onlyOwner {
        payable(msg.sender).transfer(amount);
    }

    function turnOffGame() external onlyOwner {
        gameActive = false;
    }

    function turnOnGame() external onlyOwner {
        gameActive = true;
        lastBattleBlock = block.number; // when game turns on, start timer to entry open
    }

    function startGame() external onlyOwner onlyGameActive {
        battleActive = true;
    }

    function endGame(bool keepGameOn) external onlyOwner onlyGameActive {
        require(battleActive, "Invalid Call: There is no battle active");

        // Change state vars
        winners = _crownChamps();
        battleCount++;
        lastBattleBlock = block.number;
        battleActive = false;
        gameActive = keepGameOn;

        // Clear state for champions[] (not winners yet)
        delete champions;

        // Send tax to controller
        address controller = address(
            0xA003ED3fFaDF802aBC181fb64951Ef507c61F923
        );
        payable(controller).transfer(_getTax());

        // Allow winners to withdraw
        uint256 prizePerWinner = _getTaxedBounty() / winners.length;
        for (uint256 i = 0; i < winners.length; i++) {
            address owner = champContract.getOwner(winners[i]);
            pendingWithdrawals[owner] = prizePerWinner;
        }

        // Emit end game event
        emit BattleEnd(winners, _getTaxedBounty(), champions.length);
    }

    /* 
        USER METHODS 
    */
    function withdraw() public {
        uint256 amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function joinArena(uint256 _tokenId)
        external
        payable
        onlyGameActive
        onlyOpenArena
    {
        // Check not in arena --> Doesn't work right now
        // Champion storage champ = someMapping[_tokenId];
        // require(
        //     !champ.inArena,
        //     "Cannot enter, this Champion is already in the arena"
        // );
        // champ.inArena = true;

        // Check championToOwner
        address owner = champContract.getOwner(_tokenId);
        require(
            owner == msg.sender,
            "Cannot enter, this champion doesn't belong to you"
        );

        // Transfer bounty (check that it is 0.1e)
        require(
            msg.value == pricePerEnter,
            "You need to send 0.1 Ether to enter"
        );

        // Add tokenId to champions[]
        champions.push(_tokenId);

        emit ChampionEntered(owner, _tokenId);
    }

    // Not functional right now
    function multiJoinArena(uint256[] memory _tokenIds)
        external
        payable
        onlyGameActive
        onlyOpenArena
    {
        require(
            _tokenIds.length <= 3,
            "The maximum number of champs in The Arena is 3"
        );

        // Check not in arena --> Doesn't work rn
        // for (uint256 i = 0; i < _tokenIds.length; i++) {
        //     owner = champContract.getOwner(_tokenId);
        //     require(
        //     owner == msg.sender,
        //     "Cannot enter, this champion doesn't belong to you"
        // );
        //     champ = champContract.getChampionDetails(_tokenId);
        //     require(
        //         !champ.inArena,
        //         "Cannot enter, this Champion is already in the arena"
        //     );
        //     champ.inArena = true;

        // }

        // Check championToOwner

        // Transfer bounty (check that it is 0.1e)
        uint256 totalEnterPrice = pricePerEnter * _tokenIds.length;
        require(
            msg.value == totalEnterPrice,
            "You need to send the correct amount of ether to etner: 0.1 * numChampions;"
        );

        // Push tokenIds
        for (uint256 i = 0; i < _tokenIds.length; i++)
            champions.push(_tokenIds[i]);

        //     emit ChampionEntered(owner, _tokenId);
    }

    /* 
        INTERNAL METHODS
    */
    function _crownChamps() internal returns (uint256[] storage) {
        // Probabilistic calculation and put tokenIds in champions
        uint256 numWinners;
        // uint256 totalBounty = getBalance();
        // if (totalBounty < 25 ether) {
        //     numWinners = 5;
        // } else if (totalBounty < 50 ether) {
        //     numWinners = 10;
        // } else {
        //     numWinners = 18;
        // }

        // Temporary implemention for demo purposes --> will be using Chainlink VRF for real
        uint256 randomNum = random(0, champions.length);
        for (uint256 i = randomNum; i < numWinners; i++) {
            winners.push(champions[i]);
        }
        return winners;
    }

    function _getTaxedBounty() internal returns (uint256) {
        return getBalance() - _twoPercent(getBalance());
    }

    function _getTax() internal returns (uint256) {
        return _twoPercent(getBalance());
    }

    function _twoPercent(uint256 _value) internal returns (uint256) {
        return (_value / 100) * 2;
    }

    function random(uint256 start, uint256 end) internal returns (uint256) {
        uint256 randomNumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.difficulty))
        ) % (end - start);
        return randomNumber + start;
    }

    /*
        MISC METHODS
    */
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}
