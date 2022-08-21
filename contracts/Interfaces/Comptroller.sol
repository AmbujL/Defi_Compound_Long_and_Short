// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



interface Comptroller {

  function enterMarkets(address[] calldata) external returns (uint[] memory);
  function exitMarket(address cToken)  external returns (uint);
  function getAccountLiquidity(address)
    external
    view
    returns (
      uint,
      uint,
      uint
    );

  function liquidateCalculateSeizeTokens(
    address cTokenBorrowed,
    address cTokenCollateral,
    uint actualRepayAmount
  ) external view returns (uint, uint);

}

interface PriceFeed {
  function getUnderlyingPrice(address cToken) external view returns (uint);
}