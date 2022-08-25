require("dotenv").config();
import CompoundLongingContract from "../build/CompoundLonging.json";
const ropstenAddress = require("../RopstenAddresess.json");
const Web3 = require("web3");
const Provider = require("@truffle/hdwallet-provider");


const address = process.env.ADDRESS;
const privateKey = process.env.PRIVATEKEY;
const ethEndPointURL = process.env.ETH_ROPSTEN_URL;

 const provider = new Provider(privateKey, ethEndPointURL);
  const web3 = new Web3(provider);
  const networkID = web3.eth.net.getId();
  const contract = web3.eth.Contract(
    CompoundLongingContract.abi,
    CompoundLongingContract.networks[networkID].address
  );

const long = async () => {

    contract.methods
      .initialize(
        ropstenAddress.Contracts.cETH,
        process.env.ZERO_ADDRESS,
        ropstenAddress.Contracts.cUSDT,
        ropstenAddress.Contracts.USDT
      )
      .send({ from: address })
      .then((response) => {
        console.log(response?.event?.Initialized);
      });
  
  contract.methods.supplyEth().send({ from: address, value: 1 * 10 ** 18 }).then((response) => {
        console.log(response?.event?.AssetSupplied);     
      });
  
      const maxBorrow=contract.methods.getMaxBorrow();
      contract.methods.long(Number(maxBorrow*0.6));    //taking 60 % of maxborrow to avoid getting liquadated
  
};


const Repay = async () => {
  contract.methods.repay().send({from: address });
};
