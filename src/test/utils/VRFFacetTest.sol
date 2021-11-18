// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "ds-test/test.sol";

import "../../VRFFacet.sol";
import "./Hevm.sol";

import "../lib/getERC20.sol";

import "../../interfaces/IchainlinkPegSwap.sol";

// interface DLC {
//   function balanceOf(address) external returns (uint256);

//   /// TODO add burn function to DLC
//   function transfer(address, uint256) external returns (bool);
// }
interface ENS {
  function balanceOf(address) external returns (uint256);

  /// TODO add burn function to DLC
  function transfer(address, uint256) external returns (bool);
}

// interface WETH {
//   function balanceOf(address) external returns (uint256);

//   /// TODO add burn function to DLC
//   function transfer(address, uint256) external returns (bool);

//   function transferFrom(
//     address,
//     address,
//     uint256
//   ) external returns (bool);

//   function approve(address, uint256) external returns (bool);
// }

contract FruitfulPlayer is GetERC20 {
  VRFFacet vrfFacet;
  DLC dlc;
  LinkTokenInterface link;
  WETH wethSC;
  IChainlinkPegSwap cps = IChainlinkPegSwap(0xAA1DC356dc4B18f30C347798FD5379F3D77ABC5b);

  constructor(
    VRFFacet _vrfFacet,
    DLC _dlc,
    LinkTokenInterface _link,
    WETH _wethSC
  ) {
    vrfFacet = _vrfFacet;
    dlc = _dlc;
    link = _link;
    wethSC = _wethSC;
    // emit log_named_address("msg.sender in constructor of FruitfulPlayer", msg.sender);
    // payable(msg.sender).transfer(1);
  }

  function mintGenesis(uint256 donation) public {
    vrfFacet.mintGenesis(donation);
  }

  function approveLove(address spender, uint256 amount) public {
    dlc.approve(spender, amount);
  }

  function approveWETH(address spender, uint256 amount) public {
    wethSC.approve(spender, amount);
  }

  function approveLink(address spender, uint256 amount) public {
    link.approve(spender, amount);
  }

  // fund all players with base currency
  // address(this).transfer(100);
  // this.transfer(10);
  // msg.sender.call{value: 10}("");

  // pay = payable(msg.sender);

  receive() external payable {}

  fallback() external payable {}
}

contract VRFFacetTest is GetERC20, DSTest {
  Hevm internal constant hevm = Hevm(HEVM_ADDRESS);
  DLC internal dlc;
  ENS internal ens;
  LinkTokenInterface internal link;
  WETH internal wethSC;
  IChainlinkPegSwap cps = IChainlinkPegSwap(0xAA1DC356dc4B18f30C347798FD5379F3D77ABC5b);
  LinkTokenInterface internal link677 = LinkTokenInterface(0xb0897686c545045aFc77CF20eC7A532E3120E0F1);

  // address public constant love = 0x69bdE563680f580A2da5b5d4E202ecA4FDF35664;

  // contracts
  VRFFacet internal vrfFacet;

  // players
  FruitfulPlayer internal haibara;

  // EOA
  address public constant fruitfulEOA = 0x287300059f50850d098b974AbE59106c4F52c989;

  function setUp() public virtual {
    dlc = DLC(0x69bdE563680f580A2da5b5d4E202ecA4FDF35664);
    ens = ENS(0xC18360217D8F7Ab5e7c516566761Ea12Ce7F9D72);
    link = LinkTokenInterface(0x53E0bca35eC356BD5ddDFebbD1Fc0fD03FaBad39);
    wethSC = WETH(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);

    // deploy contracts
    vrfFacet = new VRFFacet("Fruitful Metaverse Base Character", "FID", "TESTURI");
    // create haibara's account
    haibara = new FruitfulPlayer(vrfFacet, dlc, link, wethSC);
    // payable(address(this)).transfer(1);
    emit log_named_uint("Player's base currency balance", address(haibara).balance);
    emit log_named_uint("Test contract base currency balance", address(this).balance);

    // haibara.getERC20(love, 10e18);
    getERC20(love, 100e18);
    dlc.transfer(address(haibara), 20e18);
    emit log_named_uint("haibara Love balance", dlc.balanceOf(address(haibara)));
    // link.approve(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff, 10e18);
    /// obtain LINK tokens from quickswap
    getERC20Quick(address(link), 10e18);

    /// swap LINK tokens into ERC677 compatible LINK tokens
    link.approve(address(cps), 10e18);
    cps.swap(10e18, address(link), address(link677));

    /// transferring the ERC-677 LINK tokens to the VRFFacet contract
    link677.transfer(address(vrfFacet), 10e18);

    // getERC20Quick(address(wethSC), 10e18);
    getERC20WithMatic(address(wethSC), 90_000e18);

    wethSC.transfer(address(haibara), 10e18);
    emit log_named_uint("haibara WETH balance", wethSC.balanceOf(address(haibara)));

    emit log_address(msg.sender);
    // emit log_uint(weth.balanceOf(msg.sender));
    emit log_uint(msg.sender.balance);
    // getERC20(love, 10 * 10**18);
    // weth.approve(msg.sender, 1 * 10**15); // I need this contract to be approved
    // weth.transferFrom(msg.sender, address(vrfFacet), 1 * 10**15);
    // weth.transfer(address(vrfFacet), 1 * 10**15);
  }
}
