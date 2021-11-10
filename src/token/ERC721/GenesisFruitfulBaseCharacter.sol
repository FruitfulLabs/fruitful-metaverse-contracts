// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@solidstate/contracts/token/ERC721/ERC721.sol";

import "@solidstate/contracts/token/ERC721/metadata/ERC721Metadata.sol";

import "../../BaseCharacterStorage.sol";
import "../../CharacterSkillsStorage.sol";

interface DLC {
  function balanceOf(address) external returns (uint256);
}

contract GenesisFruitfulBaseCharacter is ERC721 {
  DLC dlc;

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

  function mintGenesisCharacter(
    address player,
    uint256 tokenId /// returns (uint256)
  ) public {
    dlc = DLC(0x69bdE563680f580A2da5b5d4E202ecA4FDF35664);
    require(
      dlc.balanceOf(player) >= 10 * 10**18,
      "mintGenesisCharacter: Love balance is not enough"
    );
    require(
      totalSupply() <= 2_000,
      "mintGenesisCharacter: total supply is > 2_000"
    );

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
    require(
      dlc.balanceOf(player) >= 10 * 10**18,
      "mintGenesisCharacter: Love balance is not enough"
    );
    require(
      totalSupply() <= 2_000,
      "mintGenesisCharacter: total supply is > 2_000"
    );

    BaseCharacterStorage.Layout storage l = BaseCharacterStorage.layout();
    l.empathy[player] = ethDonationAmount;
    _mint(player, tokenId);
  }

  /// @notice temporary view helper methods
  function viewEmpathy(address player) public view returns (uint256) {
    return BaseCharacterStorage.layout().empathy[player];
  }
}
/// @kevin-fruitful change solidstate app storage hash to fruitful at the end of dev
