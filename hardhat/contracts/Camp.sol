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
    * OVERRIDE METHODS *  
    *******************/
    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
