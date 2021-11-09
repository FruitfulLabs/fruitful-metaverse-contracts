// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library CharacterSkillsStorage {
  struct Layout {
    /// @note The following are attributes of a genesis base character in the Fruitful Metaverse
    /// @note Skill Attributes
    mapping(address => uint256) code;
    mapping(address => uint256) art;
    mapping(address => uint256) shill;
    mapping(address => uint256) educate;
  }

  bytes32 internal constant STORAGE_SLOT =
    keccak256("fruitful.contracts.storage.CharacterSkills");

  function layout() internal pure returns (Layout storage l) {
    bytes32 slot = STORAGE_SLOT;
    assembly {
      l.slot := slot
    }
  }
}
