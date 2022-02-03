//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

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
    
    // IPFS URI
    string public baseTokenURI;

    // the arena's contract address
    address arena;

    // mint price
    uint256 public constant MINT_PRICE = .001 ether; 
    
    // maximum mint per wallet
    uint256 public MAX_PER_WALLET;

    // total supply 
    uint256 public MAX_CHAMPIONS;
    bool public saleIsActive = false;

    /**
     *  Modifiers
     */

    modifier onlyActive() {
        require(saleIsActive, "Minting is not live");
        _;
    }

    modifier onlyArena() {
        require(msg.sender == arena, "Not arena contract");
        _;
    }

    /**
        Instantiates contracts and rarity tables
     */
    constructor(uint256 _maxPerWallet, uint256 _maxSupply, string memory _URI) ERC721("Chain Champion", "CC") {
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

    /**
     * READ METHODS
     */

    function getTokenTraits(uint256 tokenId) external view returns (ChampionStruct memory) {
        return tokenTraits[tokenId];
    }

    

    /**
     *  USER METHODS
     */
    function mint(uint256 _amount) external payable onlyActive {
        uint256 totalMinted = _tokenIds.current();

        require(totalMinted.add(_amount) <= MAX_CHAMPIONS, "Not enough");
        require(_amount > 0 && _amount <= MAX_PER_WALLET, "Cannot mint this amount");
        require(msg.value >= MINT_PRICE.mul(_amount), "Not enough Ether to mint this amount");

        for(uint256 i = 0; i < _amount; i++) {
            _mintSingle();
        }
    }

    function _mintSingle() private {
        _safeMint(msg.sender, _tokenIds.current());
        _tokenIds.increment();
    }

    function tokensOfOwner(address _owner) 
            external 
            view 
            returns (uint[] memory) {
        uint tokenCount = balanceOf(_owner);
        uint[] memory tokensId = new uint256[](tokenCount);
        for (uint i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
     
        return tokensId;
    }



    /**
     *  ARENA METHODS
     */
    function incrementWins(uint256[] memory tokenIds, uint256 winnings) external onlyArena {
        for(uint256 i = 0; i < tokenIds.length; i++) {
            ChampionStruct storage curr = tokenTraits[i];
            curr.numWins++;
            curr.totalWinnings += winnings;
        }
    }

    /**
     * ADMIN METHODS
     */

    function reserve() public onlyOwner {
        uint256 totalMinted = _tokenIds.current();

        require(totalMinted.add(30) < MAX_CHAMPIONS, "Not enough");

        for(uint256 i = 0; i < 30; i++) {
            _mintSingle();
        }
    }

    /**
     * allows owner to withdraw funds from minting
     */
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function _baseURI() internal 
                    view 
                    virtual 
                    override 
                    returns (string memory) {
     return baseTokenURI;
    }
    
    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }   

    /**
     * enables owner to pause / unpause minting
     */
    function setPaused(bool _paused) external onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }

    /**
     * set arena address (failsafe)
     */
     function setArena(address _arena) external onlyOwner {
         arena = _arena;
     }
             
}
