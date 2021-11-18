// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library BaseCharacterStorage {
  struct Layout {
    uint256 baseCharMaxSupply;
    /// @dev we only want each wallet to be able to own 1 base character
    mapping(address => uint256) baseCharId;
    /// @note The following are attributes of a genesis base character in the Fruitful Metaverse
    /// @note Core Attributes
    mapping(uint256 => uint256) xp;
    mapping(uint256 => uint256) hp;
    mapping(uint256 => uint256) stamina;
    mapping(uint256 => uint256) mana;
    /// @note Emotional Attributes
    mapping(address => uint256) happiness;
    // mapping(address => uint256) empathy;
    mapping(uint256 => uint256) empathy;
    mapping(address => uint256) luckiness;
    mapping(address => uint256) patience;
    mapping(address => uint256) sadness;
  }

  bytes32 internal constant STORAGE_SLOT = keccak256("fruitfulGenesis.contracts.storage.BaseCharacter");

  function layout() internal pure returns (Layout storage l) {
    bytes32 slot = STORAGE_SLOT;
    assembly {
      l.slot := slot
    }
  }
}
