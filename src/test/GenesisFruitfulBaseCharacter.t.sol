// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utils/GenesisFruitfulBaseCharacterTest.sol";

// import { Errors } from "../Greeter.sol";

contract MintGenesisCharacter is GenesisFruitfulBaseCharacterTest {
  //   function testMint(address player, uint256 tokenId) public {
  //     uint256 previousTotalSupply = genesisFBC.totalSupply();
  //     if (player != address(0) && tokenId <= 2_000) {
  //       genesisFBC.mintGenesisCharacter(player, tokenId);
  //     }
  //     uint256 currentTotalSupply = genesisFBC.totalSupply();
  //     // assertEq(genesisFBC.totalSupply(), previousTotalSupply + 1);
  //     assertEq(currentTotalSupply, previousTotalSupply + 1);
  //   }
  // }
  // function testMint(address player, uint256 tokenId) public {
  //   uint256 previousTotalSupply = genesisFBC.totalSupply();
  //   emit log_uint(genesisFBC.totalSupply());
  //   if (player != address(0)) return;
  //   if (dlc.balanceOf(player) < 10 * 10**18) return;
  //   genesisFBC.mintGenesisCharacter(player, tokenId);
  //   assertEq(genesisFBC.totalSupply(), previousTotalSupply + 1);
  //   // emit log_uint(genesisFBC.totalSupply());
  //   // uint256 currentTotalSupply = genesisFBC.totalSupply();
  //   // assertEq(genesisFBC.totalSupply(), genesisFBC.totalSupply() - 1);
  // }
  // function testMintWithEmpathy(
  //   address player,
  //   uint256 tokenId,
  //   uint256 ethDonationAmount
  // ) public {
  //   uint256 previousTotalSupply = genesisFBC.totalSupply();
  //   emit log_uint(genesisFBC.totalSupply());
  //   if (player != address(0)) return;
  //   if (dlc.balanceOf(player) < 10 * 10**18) return;
  //   genesisFBC.mintGenesisCharacterWithEmpathy(
  //     player,
  //     tokenId,
  //     ethDonationAmount
  //   );
  //   assertEq(genesisFBC.totalSupply(), previousTotalSupply + 1);
  //   assertEq(genesisFBC.viewEmpathy(player), ethDonationAmount);
  //   // emit log_uint(genesisFBC.totalSupply());
  //   // uint256 currentTotalSupply = genesisFBC.totalSupply();
  //   // assertEq(genesisFBC.totalSupply(), genesisFBC.totalSupply() - 1);
  // }
}
