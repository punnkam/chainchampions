//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "./Base64.sol";

contract Champion is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 idDigits = 8;
    uint256 idMod = 10**idDigits;

    constructor() ERC721("Champions", "CHAMP") {
        console.log("Deployed champs");
    }

    struct Champion {
        uint256 id;
        uint256 token;
        uint256 numWins;
        uint256 level;
        string imageURI;
    }

    Champion[] public champions;

    mapping(uint256 => Champion) public tokenToChampion;
    mapping(uint256 => address) public championToOwner;
    mapping(address => uint256) ownerChampionCount;

    function mintChampion(uint256 _id) public {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenToChampion[newItemId] = Champion({
            id: _id,
            token: newItemId,
            numWins: 0,
            level: 1,
            imageURI: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/440px-Image_created_with_a_mobile_phone.png"
        });
        championToOwner[newItemId] = msg.sender;
        ownerChampionCount[msg.sender]++;
        _tokenIds.increment();
    }

    function getOwner(uint256 _tokenId) public view returns (address) {
        return championToOwner[_tokenId];
    }

    function getChampionCount(address _owner) public view returns (uint256) {
        return ownerChampionCount[_owner];
    }

    function getChampionDetails(uint256 _tokenId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        Champion memory guy = tokenToChampion[_tokenId];
        return (guy.token, guy.id, guy.numWins, guy.level);
    }

    function _generateRandomId() private view returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp)));
        return rand % idMod;
    }

    function createRandomChampion() public {
        uint256 randId = _generateRandomId();
        mintChampion(randId);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        Champion memory currChamp = tokenToChampion[_tokenId];

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                "Champion",
                " -- NFT #: ",
                Strings.toString(_tokenId),
                '", "description": "This champion is going to take over the arena!", "image": "',
                "https://i.imgur.com/efLejde.jpeg",
                '", "attributes": [ { "trait_type": "Number of Wins", "value": ',
                Strings.toString(currChamp.numWins),
                '}, { "trait_type": "Level", "value": ',
                Strings.toString(currChamp.level),
                '}, { "trait_type": "Champion ID", "value": ',
                Strings.toString(currChamp.id),
                "} ]}"
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }
}
