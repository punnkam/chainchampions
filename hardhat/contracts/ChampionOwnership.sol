pragma solidity >=0.5.0 <0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Champion.sol";

contract ChampionOwnership is ERC721, Champion {

  mapping (uint => address) championApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerChampionCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return championToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerChampionCount[_to] = ownerChampionCount[_from_to]++;
    ownerChampionCount[_frommsg.sender] = ownerChampionCount[_frommsg.sender]--;
    championToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
      require (championToOwner[_tokenId] == msg.sender || championApprovals[_tokenId] == msg.sender);
      _transfer(_from, _to, _tokenId);
    }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
      championToOwner[_tokenId] = _approved;
      emit Approval(msg.sender, _approved, _tokenId);
    }

}
