# Compound Protocol Longing and Shorting (DeFi Application)

This project is a decentralized finance (DeFi) application built to perform longing and shorting of crypto assets using the **Compound Finance** protocol and **Uniswap** as the market exchange. The application is developed using **Node.js**, **web3.js**, **Solidity**, **Truffle**, and the **OpenZeppelin** library.

## Features

- **Supply Assets:** Supply ETH or ERC20 tokens to the Compound protocol.
- **Enter Markets:** Borrow other asset classes using the supplied assets as collateral.
- **Asset Exchange:** Utilize Uniswap to exchange borrowed assets for the supplied assets or vice versa.
- **Profit Realization:** Redeem profits after market price changes by re-exchanging assets and repaying loans with interest.

## Workflow

1. **Supply Assets:** Users supply ETH or tokens to Compound CERC20/CEth contracts.
2. **Enter Market:** Users enter the market to borrow assets.
3. **Exchange Assets:** Borrowed assets are exchanged with the supplied asset using Uniswap.
4. **Market Price Increase:** After a price increase, supplied assets are re-exchanged against the borrowed asset.
5. **Repay Loan:** Borrowed asset and accrued interest are repaid to CERC20/CEth contracts.

## Smart Contract Details

### Contract: `CompoundLonging`

- **Supply and Borrow Mechanism:**
  - Supports ETH or ERC20 tokens for supply.
  - Supports borrowing ERC20 tokens via Compound protocol.
- **Interaction with Uniswap:**
  - Facilitates swapping of tokens or ETH.
- **Profit Calculation and Redemption:**
  - Enables repaying the borrowed amount with interest and redeeming profits.

### Key Functions:

1. `initialize`: Configures the contract with necessary asset details.
2. `supplyEth`: Supplies ETH as collateral to Compound.
3. `supplyToken`: Supplies ERC20 tokens as collateral to Compound.
4. `long`: Borrows assets and exchanges them using Uniswap.
5. `repay`: Repays borrowed assets with interest and redeems supplied assets.
6. `getMaxBorrow`: Calculates the maximum amount of an asset that can be borrowed.
7. `getSuppliedBalance` and `getBorrowBalance`: Retrieve the current balances of supplied and borrowed assets.
8. `getAccountLiquidity`: Fetches the current account liquidity and shortfall.

## Prerequisites

- Node.js
- Truffle Framework
- Ganache
- MetaMask (for testing in a browser environment)

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd compound-longing
   ```
3. Install dependencies:
   ```bash
   npm install
   ```
4. Start Ganache:
   ```bash
   ganache-cli
   ```
5. Deploy contracts:
   ```bash
   truffle migrate
   ```

## Configuration

- Ensure the following configurations are updated as per your network:
  - Addresses for **Compound Comptroller**, **Price Feed**, **Uniswap Router**, and token contracts.
  - Update these addresses in the smart contract file before deployment.

## Testing

1. Run the Truffle tests:
   ```bash
   truffle test
   ```
2. Interact with the contract using a front-end interface or a CLI script.

## Usage

- Supply assets by calling `supplyEth` or `supplyToken`.
- Borrow assets and execute longing by calling the `long` function.
- Repay borrowed assets and redeem profits using the `repay` function.

## File Structure

- **contracts/**: Contains the Solidity smart contracts.
- **migrations/**: Deployment scripts for Truffle.
- **test/**: Truffle tests for the smart contracts.
- **src/**: Contains JavaScript files for interacting with the smart contract.

## Future Enhancements

- Add front-end integration for better user interaction.
- Support additional DeFi protocols for diversified trading.
- Implement more robust error handling and logging.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Compound Finance**: For providing the protocol for lending and borrowing.
- **Uniswap**: For enabling decentralized asset exchange.
- **OpenZeppelin**: For secure and reusable smart contract libraries.
