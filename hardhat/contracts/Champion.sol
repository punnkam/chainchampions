//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/**
 * @title Champion
 * @author Punn Kam
 * @dev An implementation of the Champion ERC721 contract, a generic NFT implementation.
 *
 */

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract Champion is ERC721Enumerable, Ownable, Pausable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public baseTokenURI; // IPFS URI
    address arena; // the arena's contract address
    uint256 public constant MINT_PRICE = .001 ether; // mint price
    uint256 public MAX_PER_WALLET; // maximum mint per wallet
    uint256 public MAX_CHAMPIONS; // total supply
    bool public saleIsActive = true; // bool for activeSale

    /*******************
    **** MODIFIERS ****  
    *******************/

    modifier onlyActive() {
        require(saleIsActive, "Minting is not live");
        _;
    }

    modifier onlyArena() {
        require(msg.sender == arena, "Not arena contract");
        _;
    }
    
    /**
     * @dev Initalizes the Champion contract and sets limit parameters.
     */
    constructor(
        uint256 _maxPerWallet,
        uint256 _maxSupply,
        string memory _URI
    ) ERC721("Chain Champion", "CC") {
        MAX_PER_WALLET = _maxPerWallet;
        MAX_CHAMPIONS = _maxSupply;
        setBaseURI(_URI);
    }

    struct ChampionStruct {
        uint256 id;
        uint256 token;
        uint256 numWins;
        uint256 totalWinnings;
        uint256 level;
        string imageURI;
    }

    // mapping from tokenId to a struct containing the Champion's traits
    mapping(uint256 => ChampionStruct) public tokenTraits;
    // mapping from hashed(tokenTrait) to tokenId
    mapping(uint256 => uint256) public existingTraits;

    /*******************
    *** VIEW METHODS ***  
    *******************/

    /**
     * @dev Returns a struct of the Champion's data given tokenId.
     */
    function getTokenTraits(uint256 tokenId)
        external
        view
        returns (ChampionStruct memory)
    {
        return tokenTraits[tokenId];
    }

    /*******************
    *** USER METHODS ***  
    *******************/

    /**
     * @dev Mint X number of champions to caller's wallet (must be less than limit).
     */
    function mint(uint256 _amount) external payable onlyActive {
        uint256 totalMinted = _tokenIds.current();

        require(totalMinted.add(_amount) <= MAX_CHAMPIONS, "Not enough");
        require(
            _amount > 0 && _amount <= MAX_PER_WALLET,
            "Cannot mint this amount"
        );
        require(
            msg.value >= MINT_PRICE.mul(_amount),
            "Not enough Ether to mint this amount"
        );

        for (uint256 i = 0; i < _amount; i++) {
            _mintSingle();
        }
    }

    /**
     * @dev Initalizes the Champion contract and sets limit parameters.
     */
    function _mintSingle() private {
        _safeMint(msg.sender, _tokenIds.current());
        _tokenIds.increment();
    }

    /**
     * @dev Returns a list of tokens owned by an address.
     */
    function tokensOfOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    /*******************
    *** ARENA METHODS **  
    *******************/

    /**
     * @dev Edit Champion metadata to increment its win count by modifying the struct. 
     */
    function incrementWins(uint256[] memory tokenIds, uint256 winnings)
        external
        onlyArena
    {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            ChampionStruct storage curr = tokenTraits[i];
            curr.numWins++;
            curr.totalWinnings += winnings;
        }
    }

    /*******************
    *** ADMIN METHODS **  
    *******************/

    /**
     * @dev Reserve a fixed number of Champions for the team.
     *      Only the owner can call the function.
     */
    function reserve() public onlyOwner {
        uint256 totalMinted = _tokenIds.current();

        require(totalMinted.add(30) < MAX_CHAMPIONS, "Not enough");

        for (uint256 i = 0; i < 30; i++) {
            _mintSingle();
        }
    }

    /**
     * @dev Withdraw funds from the contract
     * Only the owner can call the function.
     */
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    /**
     * @dev Change the active state of the contract.
     * Only the owner can call the function.
     */
    function setPaused(bool _paused) external onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }

    /**
     * @dev Set the arena contract address
     * Only the owner can call the function.
     */
    function setArena(address _arena) external onlyOwner {
        arena = _arena;
    }

    /*******************
    * INTERNAL METHODS *  
    *******************/

    /**
     * @dev Return the baseTokenURI.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    /**
     * @dev Set the baseURI
     */
    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    
}
