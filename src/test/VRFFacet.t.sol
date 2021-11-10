// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/VRFFacetTest.sol";

contract MintGenesisTest is VRFFacetTest {
  function testMint(address player, uint256 tokenId) public {
    vrfFacet.mintGenesis(tokenId);
  }
}
