// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "ds-test/test.sol";

import "../../token/ERC721/GenesisFruitfulBaseCharacter.sol";
import "./Hevm.sol";

// interface DLC {
//   function balanceOf(address) external returns (uint256);
// }

abstract contract GenesisFruitfulBaseCharacterTest is DSTest {
  Hevm internal constant hevm = Hevm(HEVM_ADDRESS);
  DLC dlc;

  // contracts
  GenesisFruitfulBaseCharacter internal genesisFBC;

  // EOA
  address public constant fruitfulEOA =
    0x287300059f50850d098b974AbE59106c4F52c989;

  function setUp() public virtual {
    dlc = DLC(0x69bdE563680f580A2da5b5d4E202ecA4FDF35664);
    genesisFBC = new GenesisFruitfulBaseCharacter(
      "Fruitful Metaverse Genesis Base Characters",
      "FM-NFT",
      "UPDATEBASEURI"
    );
  }
}
