//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./Champion.sol";
import "./EXP.sol";

contract Camp is Ownable, IERC721Receiver, Pausable {

    /*******************
    ***** STORAGE ******  
    *******************/

    // struct to store a stake's token, owner, and earning values
    struct Stake {
        uint16 tokenId;
        uint80 value;
        address owner;
    }

    Champion champion; // ref to Champion contract
    EXP exp; // ref to Token contract (EXP)

    mapping(uint256 => Stake) public camp; // maps tokenId to stake
    uint256 public constant EXP_YIELD = 8888 ether; // rate of $EXP token reward
    uint256 public constant MINIMUM_TIME = 1 days; // minimum time before earning rewards
    uint256 public constant MAX_REWARDS = 500000000 ether; // maximum $EXP emissions from camp

    uint256 public totalExpEarned; // amount of $EXP earned so far
    uint256 public totalChampStaked; // number of Champions staked in camp
    uint256 public lastClaimTime; // last timestamp that claiming was allowed

    /*******************
    ****** EVENTS ******  
    *******************/

    event TokenStaked(address owner, uint256 tokenId, uint256 value);
    event TokenUnstaked(uint256 tokenId, uint256 earned, bool unstaked);
    
    /*******************
    **** MODIFIERS ****  
    *******************/

    modifier _updateEarnings() {
        if (totalExpEarned < MAX_REWARDS) {
        totalExpEarned += 
            (block.timestamp - lastClaimTime)
            * totalChampStaked
            * EXP_YIELD / 1 days; 
        lastClaimTime = block.timestamp;
        }
        _;
    }

    /**
     * @dev Initalizes the Camp contract and sets contract addresses.
     * @param _champion Assigns Champion contract address to reference
     * @param _exp Assigns EXP contract address to reference
     */
    constructor(address _champion, address _exp) {
        champion = Champion(_champion);
        exp = EXP(_exp);
    }

    /*******************
    *** VIEW METHODS ***  
    *******************/

    /**
     * @dev Returns the count of Champions.
     */
    function getChampCount() public view returns(uint256, uint256, uint256, bool) {
        
    }

    /*******************
    *** USER METHODS ***  
    *******************/

    /**
     * Adds multiple Champions to camp
     * @param account The address of the staker
     * @param tokenIds The IDs of the Champions to stake
     */
    function stakeMany(address account, uint16[] calldata tokenIds) external {
        
    }

    /**
     * Claim reward from camp and indicate whether to unstake
     * @param tokenIds The IDs of the Champions to stake
     * @param unstake Whether or not to unstake Champion
     */
    function claimMany(uint16[] calldata tokenIds, bool unstake) external {
        
    }

    /*******************
    *** ADMIN METHODS **  
    *******************/

    /**
     * Enables owner to pause / unpause minting
     * @param _paused Paused or not
     */
    function setPaused(bool _paused) external onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }

    /*******************
    * INTERNAL METHODS *  
    *******************/

    /**
     * Add single Champion to camp
     * @param account The address of the staker
     * @param tokenId The Champion's tokenId to stake
     */
    function _stake(address account, uint256 tokenId) internal {
        
    }

    /**
     * Claim rewards for camp
     * @param tokenId The Champion's tokenId to stake
     * @param unstake Whether to unstake Champion
     */
    function _claim(uint256 tokenId, bool unstake) internal {
        
    }

    /*******************
    * OVERRIDE METHODS *  
    *******************/
    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
