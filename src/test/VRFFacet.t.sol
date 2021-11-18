// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/VRFFacetTest.sol";

contract MintGenesisTest is VRFFacetTest {
  /// @dev https://docs.chain.link/docs/vrf-contracts/
  function testMint(uint256 donation) public {
    /// @dev for Polygon network
    uint256 newFee = 1e14;
    bytes32 keyHash = 0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da;
    address vrfCoordinator = 0x3d2341ADb2D31f1c5530cDC622016af293177AE0;
    address linkConverted = 0xb0897686c545045aFc77CF20eC7A532E3120E0F1;
    /// @dev set vrf inputs for the first time
    vrfFacet.changeVrf(newFee, keyHash, vrfCoordinator, linkConverted);
    // if (dlc.balanceOf(msg.sender) < 10 * 10**18) return;
    emit log_named_uint("testMint donation amount", donation);

    if (dlc.balanceOf(address(haibara)) < 10e18) return;
    // emit log_named_uint("testMint donation", wethSC.balanceOf(address(haibara)));

    if (wethSC.balanceOf(address(haibara)) < donation) return;

    emit log_named_address("msg.sender", msg.sender);
    emit log_named_uint("haibara Love balance", dlc.balanceOf(address(haibara)));
    emit log_named_uint("haibara WETH balance before mint", wethSC.balanceOf(address(haibara)));

    // emit log_named_uint("haibara approved vrfFacet to spend Love", dlc.balanceOf(address(haibara)));
    // dlc.approve(address(vrfFacet), 10e18);
    haibara.approveLove(address(vrfFacet), 10e18 * 2);
    haibara.approveWETH(address(vrfFacet), donation);

    emit log_named_uint("testMint haibara weth balance before mint", wethSC.balanceOf(address(haibara)));
    uint256 prevTokenId = vrfFacet.totalSupply();
    emit log_named_uint("testMint NFT totalSupply before mint", vrfFacet.totalSupply());
    emit log_named_uint("testMint empathy before mint", vrfFacet.viewEmpathy(0));
    uint256 prevLoveBalance = dlc.balanceOf(address(haibara));
    haibara.mintGenesis(donation);

    assertEq(dlc.balanceOf(address(haibara)), prevLoveBalance - 10e18);

    emit log_named_uint("testMint NFT totalSupply after mint", vrfFacet.totalSupply());

    emit log_named_uint("testMint empathy after mint 0", vrfFacet.viewEmpathy(0));
    emit log_named_uint("testMint empathy after mint 1", vrfFacet.viewEmpathy(1));

    assertEq(vrfFacet.totalSupply(), prevTokenId + 1);
    assertEq(vrfFacet.viewEmpathy(vrfFacet.totalSupply()), donation);
    assertEq(wethSC.balanceOf(address(haibara)), wethSC.balanceOf(address(haibara)) + donation);

    try haibara.mintGenesis(donation) {
      // fail();
    } catch Error(string memory error) {
      assertEq(error, "mintGenesis: msg.sender NFT balance > 0");
    }
  }

  // function testMintTwo(uint256 donation) public {
  //   if (dlc.balanceOf(address(haibara)) < 20e18) return;
  //   /// @dev should fail if an account that already owns 1 NFT attempts to mint again
  //   haibara.mintGenesis(donation);
  //   haibara.mintGenesis(donation);
  //   assertEq(vrfFacet.totalSupply(), 1);
  // }
}
