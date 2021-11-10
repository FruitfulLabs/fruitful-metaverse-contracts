// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library VRFStorage {
  struct Layout {
    ;
  }

  bytes32 internal constant STORAGE_SLOT =
    keccak256("fruitful.contracts.storage.VRF");

  function layout() internal pure returns (Layout storage l) {
    bytes32 slot = STORAGE_SLOT;
    assembly {
      l.slot := slot
    }
  }
}
