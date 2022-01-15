//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Champion is ERC721, Ownable {
    //structure for an nft

    event NewChampion(string battleType, uint id);

    uint idDigits = 16;
    uint idMod = 10 ** idDigits;

    struct Champion {
        string battleType;
        uint id;
        uint numWins;
        uint level;
        //health and max health attributes?
        //name attribute?
        //armor, attack damage attributes?
    }

    Champion[] public champions;

    mapping (uint => address) public championToOwner;
    mapping (address => uint) ownerChampionCount;

    function _createChampion(string memory _battleType, uint _id) private {
        champions.push(Champion(_battleType, _id, 0, 0));
        championToOwner[id] = msg.sender;
        ownerChampionCount[msg.sender]++;
        emit NewChampion(battleType, id);
    }

    function _generateRandomId() private view returns (uint) {
       // uint rand = uint(keccak256(abi.en))
       return rand % idMod;
    }

    function createRandomChampion() public {
        uint randId = _generateRandomId();
        uint randType = //random 0-2;
        _createChampion(randType, randId);
    }
}