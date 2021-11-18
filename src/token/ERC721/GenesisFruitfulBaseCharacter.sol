// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@solidstate/contracts/token/ERC721/ERC721.sol";

import "@solidstate/contracts/token/ERC721/metadata/ERC721Metadata.sol";

import "../../BaseCharacterStorage.sol";
import "../../CharacterSkillsStorage.sol";
// import "../../AccessControlStorage.sol";

import {OwnableStorage} from "@solidstate/contracts/access/Ownable.sol";

interface DLC {
  function balanceOf(address) external returns (uint256);
}

contract GenesisFruitfulBaseCharacter is ERC721 {
  DLC dlc;

  event PopulationGrowth(uint256 indexed baseCharMaxSupply);

  /// @dev the name, symbol, and baseURI is set on deployment.
  constructor(
    string memory name,
    string memory symbol,
    string memory baseURI
  ) {
    ERC721MetadataStorage.Layout storage l = ERC721MetadataStorage.layout();
    l.name = name;
    l.symbol = symbol;
    l.baseURI = baseURI;
  }

  /// @notice metaverse admin sets max number of base characters according to the population growth schedule
  function setBaseCharMaxSupply(uint256 baseCharMaxSupply) external {
    // AccessControlStorage.Layout storage ac = AccessControlStorage.layout();
    OwnableStorage.Layout storage os = OwnableStorage.layout();
    require(msg.sender == os.owner, "setBaseCharMax: not owner");

    BaseCharacterStorage.Layout storage l = BaseCharacterStorage.layout();
    require(l.baseCharMaxSupply < 100_000, "setBaseCharMax: possible supply cannot be more than theoretical max");

    l.baseCharMaxSupply = baseCharMaxSupply;
    emit PopulationGrowth(baseCharMaxSupply);
  }

  function mintGenesisCharacter(
    address player,
    uint256 tokenId /// returns (uint256)
  ) public {
    dlc = DLC(0x69bdE563680f580A2da5b5d4E202ecA4FDF35664);
    require(dlc.balanceOf(player) >= 10 * 10**18, "mintGenesisCharacter: Love balance is not enough");
    // ERC721MetadataStorage.Layout storage erc = ERC721MetadataStorage.layout();
    /// @dev cannot be set to a number lower than the current total supply
    // BaseCharacterStorage.Layout storage l = BaseCharacterStorage.layout();
    // require(erc.totalSupply() < l.baseCharMaxSupply, "mintGenesisCharacter: total supply is > 2_000");
    // require(erc.totalSupply() < , "setBaseCharMax: cannot mint more than setBaseCharMax");

    _mint(player, tokenId);
  }

  /// TODO send eth directly to developer fund multisig
  /// TODO randomize stats
  /// TODO increment tokenId internally
  function mintGenesisCharacterWithEmpathy(
    address player,
    uint256 tokenId,
    uint256 ethDonationAmount
  ) public payable {
    dlc = DLC(0x69bdE563680f580A2da5b5d4E202ecA4FDF35664);
    require(dlc.balanceOf(player) >= 10 * 10**18, "mintGenesisCharacter: Love balance is not enough");
    require(totalSupply() < 2_000, "mintGenesisCharacter: total supply is > 2_000");

    BaseCharacterStorage.Layout storage l = BaseCharacterStorage.layout();
    l.empathy[tokenId] = ethDonationAmount;
    _mint(player, tokenId);
  }

  /// @notice temporary view helper methods
  function viewEmpathy(uint256 _tokenId) public view returns (uint256) {
    return BaseCharacterStorage.layout().empathy[_tokenId];
  }
}
/// @kevin-fruitful change solidstate app storage hash to fruitful at the end of dev
