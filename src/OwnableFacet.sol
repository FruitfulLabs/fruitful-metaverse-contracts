// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Ownable, OwnableStorage} from "@solidstate/contracts/access/Ownable.sol";

contract OwnableFacet is Ownable {
  using OwnableStorage for OwnableStorage.Layout;

  constructor(address owner) {
    OwnableStorage.layout().setOwner(owner);
  }
}
