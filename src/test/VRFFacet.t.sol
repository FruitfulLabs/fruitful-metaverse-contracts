// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/VRFFacetTest.sol";

contract MintGenesisTest is VRFFacetTest {
  /// @dev https://docs.chain.link/docs/vrf-contracts/
  function testMint(uint256 tokenId) public {
    /// @dev for Polygon network
    uint256 newFee = 1e14;
    bytes32 keyHash = 0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da;
    address vrfCoordinator = 0x3d2341ADb2D31f1c5530cDC622016af293177AE0;
    address linkConverted = 0xb0897686c545045aFc77CF20eC7A532E3120E0F1;
    /// @dev set vrf inputs for the first time
    vrfFacet.changeVrf(newFee, keyHash, vrfCoordinator, linkConverted);
    // if (dlc.balanceOf(msg.sender) < 10 * 10**18) return;
    if (dlc.balanceOf(address(haibara)) < 10e18) return;
    emit log_named_address("msg.sender", msg.sender);
    emit log_named_uint("haibara Love balance", dlc.balanceOf(address(haibara)));
    // emit log_named_uint("haibara approved vrfFacet to spend Love", dlc.balanceOf(address(haibara)));
    // dlc.approve(address(vrfFacet), 10e18);
    haibara.approveLove(address(vrfFacet), 10e18);
    haibara.mintGenesis(tokenId);
  }
  // function testFailMint(uint256 tokenId) public {
  //   if (dlc.balanceOf(address(haibara)) < 20e18) return;
  //   /// @dev should fail if an account that already owns 1 NFT attempts to mint again
  //   haibara.mintGenesis(tokenId);
  //   haibara.mintGenesis(tokenId);
  // }
}
