// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library BaseCharacterStorage {
  struct Layout {
    /// @note The following are attributes of a genesis base character in the Fruitful Metaverse
    /// @note Core Attributes
    mapping(address => uint256) xp;
    mapping(address => uint256) hp;
    mapping(address => uint256) stamina;
    mapping(address => uint256) mana;
    /// @note Emotional Attributes
    mapping(address => uint256) happiness;
    mapping(address => uint256) empathy;
    mapping(address => uint256) luckiness;
    mapping(address => uint256) patience;
    mapping(address => uint256) sadness;
  }

  bytes32 internal constant STORAGE_SLOT =
    keccak256("fruitfulGenesis.contracts.storage.BaseCharacter");

  function layout() internal pure returns (Layout storage l) {
    bytes32 slot = STORAGE_SLOT;
    assembly {
      l.slot := slot
    }
  }
}
