// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Interfaces/CAsset.sol";
import "./Interfaces/Comptroller.sol";
import "./Interfaces/Uniswap.sol";

//longing in Token with borrowing DAI from compound ,and then exchanging DAI with WETH .

contract CompoundLonging {

 enum SupplyAsset {Eth, Token}
    SupplyAsset state;

  address public manager;
   CErc20 public cTokenSupply;   //cEth or CTokenSupply
   CErc20 public cTokenBorrow;
   IERC20 public tokenBorrow;
   IERC20 public TokenSupply;    // not required on cEth ( transfering )
   CEth public cEth ;
   uint public decimals;

   Comptroller public comptroller = Comptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);

   PriceFeed public priceFeed = PriceFeed(0x922018674c12a7F0D394ebEEf9B58F186CdE13c1);
   IUniswapV2Router private constant UNI = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
   IERC20 private constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);


    modifier onlyManager{
      require(manager == msg.sender,"Only Manager can access ");
      _;
    }

      constructor(){
        manager= msg.sender;
      }

     receive() external payable {}


     function initialize(address _cTokenToSupply,
    address _TokenToSupply,
    address _cTokenBorrow,
    address _tokenBorrow,
    uint _decimals
     ) onlyManager external {

      TokenSupply = IERC20(_TokenToSupply);
    cTokenSupply = CErc20(_cTokenToSupply);
    cTokenBorrow = CErc20(_cTokenBorrow);
    tokenBorrow = IERC20(_tokenBorrow);
    decimals = _decimals;

      if(_TokenToSupply == address(0)){
        state= SupplyAsset.Token;
      }
      else 
          state= SupplyAsset.Eth;
     }

    function supplyEth() external payable {
       require(state != SupplyAsset.Token, "Not Eligible for Eth supply");
            cEth.mint{value : msg.value};
            enterMarket(address(cEth));   
   }


    function supplyToken( uint _amount) external  {
         require(state==SupplyAsset.Token,"Not Eligible for Token supply");
        cTokenSupply.mint(_amount);
         enterMarket(address(cTokenSupply)); 
   }

   function enterMarket (address  cAsset) internal {
     address[] memory cTokens = new address[](1);
        cTokens[0] = address(cAsset);
        uint[] memory errors = comptroller.enterMarkets(cTokens);
        require(errors[0] == 0, "Comptroller.enterMarkets failed.");

   }

  function getMaxBorrow() external view returns (uint)
   {
    (uint error, uint liquidity, uint shortfall) = comptroller.getAccountLiquidity( address(this));

    require(error == 0, "error");
    require(shortfall == 0, "shortfall > 0");
    require(liquidity > 0, "liquidity = 0");

    uint price = priceFeed.getUnderlyingPrice(address(cTokenBorrow));
    uint maxBorrow = (liquidity * (10**decimals)) / price;

    return maxBorrow;

  }


  function long( uint _borrowAmount) external {

    //  AssetLonging memory assetlong = Registry[_assetToSupply][_assetToBorrow];
    //   require(assetlong.state != supplyAsset.Eth, "Not Eligible for Token supply");

    // borrow
    require(cTokenBorrow.borrow(_borrowAmount) == 0, "borrow failed");
    // buy ETH
    uint bal = tokenBorrow.balanceOf(address(this));
    tokenBorrow.approve(address(UNI), bal);

    address[] memory path = new address[](2);
    path[0] = address(tokenBorrow);
    if(state==SupplyAsset.Eth)
    {
         path[1] = address(WETH);
        UNI.swapExactTokensForETH(bal, 1, path, address(this), block.timestamp);
    }
    else if(state==SupplyAsset.Token )
    {
      path[1] = address(TokenSupply);
      UNI.swapExactTokensForTokens(bal, 1, path, address(this), block.timestamp);
    }
     
  }



  function repay() external {
    // sell ETH

    //  AssetLonging memory assetlong = Registry[_assetToSupply][_assetToBorrow];
     
    address[] memory path = new address[](2);
     path[1] = address(tokenBorrow);

     if(state==SupplyAsset.Eth)
     {
       path[0] = address(WETH);
        UNI.swapExactETHForTokens{value: address(this).balance}(
      1,
      path,
      address(this),
      block.timestamp
    );
     }
     else if (state==SupplyAsset.Token )
     {
        path[0] = address(TokenSupply);
        uint bal = TokenSupply.balanceOf(address(this));
        TokenSupply.approve(address(UNI), bal);
          UNI.swapExactTokensForTokens(bal,
      1,
      path,
      address(this),
      block.timestamp
    );

     }
    
    // repay borrow
    uint borrowed = cTokenBorrow.borrowBalanceCurrent(address(this));
    tokenBorrow.approve(address(cTokenBorrow), borrowed);
    require(cTokenBorrow.repayBorrow(borrowed) == 0, "repay failed");

    uint supplied = cTokenSupply.balanceOfUnderlying(address(this));
    require(cTokenSupply.redeemUnderlying(supplied) == 0, "redeem failed");

    // supplied ETH + supplied interest + profit (in token borrow)
  }

  // not view function
  function getSuppliedBalance() external returns (uint) {
   return  state==SupplyAsset.Token ? 
   cTokenSupply.balanceOfUnderlying(address(this)): cEth.balanceOfUnderlying(address(this));
  }

  // not view function
  function getBorrowBalance() external returns (uint) {
    return cTokenBorrow.borrowBalanceCurrent(address(this));
  }

  function getAccountLiquidity()
    external
    view
    returns (uint liquidity, uint shortfall)
  {
    // liquidity and shortfall in USD scaled up by 1e18
    (uint error, uint _liquidity, uint _shortfall) = comptroller.getAccountLiquidity(
      address(this)
    );
    require(error == 0, "error");
    return (_liquidity, _shortfall);
  }
}


