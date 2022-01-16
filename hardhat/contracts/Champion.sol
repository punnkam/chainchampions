//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Champion is ERC721, Ownable {
    //structure for an nft

    event NewChampion(string battleType, uint256 id);

    uint256 idDigits = 16;
    uint256 idMod = 10**idDigits;

    struct Champion {
        string battleType;
        uint256 id;
        uint256 numWins;
        uint256 level;
        //health and max health attributes?
        //name attribute?
        //armor, attack damage attributes?
    }

    Champion[] public champions;

    mapping(uint256 => address) public championToOwner;
    mapping(address => uint256) ownerChampionCount;

    function _createChampion(string memory _battleType, uint256 _id) private {
        champions.push(Champion(_battleType, _id, 0, 0));
        championToOwner[id] = msg.sender;
        ownerChampionCount[msg.sender]++;
        emit NewChampion(battleType, id);
    }

    function _generateRandomId() private view returns (uint256) {
        // uint rand = uint(keccak256(abi.en))
        return rand % idMod;
    }

    function createRandomChampion() public {
        uint256 randId = _generateRandomId();
        uint256 randType = _createChampion(randType, randId); //random 0-2;
    }
}
