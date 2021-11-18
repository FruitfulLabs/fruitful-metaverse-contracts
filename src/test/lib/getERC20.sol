// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../interfaces/uniswapv2.sol";
import "../../interfaces/weth.sol";

contract GetERC20 {
  /// @dev polygon addresses
  address public constant weth = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
  address public constant wmatic = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
  address public constant love = 0x69bdE563680f580A2da5b5d4E202ecA4FDF35664;

  /// @dev Love Boat Exchange Router
  UniswapRouterV2 univ2 = UniswapRouterV2(0x48d3B7FB378589bBfbF27547482E20dCE40dC20E);

  /// quickswap router
  UniswapRouterV2 quickR = UniswapRouterV2(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff);

  function getERC20(address token, uint256 _amount) public virtual {
    address[] memory path = new address[](3);
    path[0] = wmatic;
    path[1] = weth;
    path[2] = token;

    uint256[] memory ins = univ2.getAmountsIn(_amount, path);
    uint256 maticAmount = ins[0];

    univ2.swapETHForExactTokens{value: maticAmount}(_amount, path, address(this), block.timestamp + 60);
  }

  function getERC20Quick(address token, uint256 _amount) public virtual {
    address[] memory path = new address[](3);
    path[0] = wmatic;
    path[1] = weth;
    path[2] = token;

    uint256[] memory ins = quickR.getAmountsIn(_amount, path);
    uint256 maticAmount = ins[0];

    quickR.swapETHForExactTokens{value: maticAmount}(_amount, path, address(this), block.timestamp + 60);
  }

  function getERC20WithMatic(address token, uint256 _maticAmount) public virtual {
    if (token == wmatic) {
      _getWMatic(_maticAmount);
    } else {
      address[] memory path = new address[](2);
      path[0] = wmatic;
      path[1] = token;

      quickR.swapExactETHForTokens{value: _maticAmount}(0, path, address(this), block.timestamp + 60);
    }
  }

  function _getWMatic(uint256 _maticAmount) internal virtual {
    WETH(wmatic).deposit{value: _maticAmount}();
  }
}
