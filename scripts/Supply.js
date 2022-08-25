require("dotenv").config();
import CompoundLongingContract from "../build/CompoundLonging.json";
const ropstenAddress = require("../RopstenAddresess.json");
const Web3 = require("web3");
const Provider = require("@truffle/hdwallet-provider");


const address = process.env.ADDRESS;
const privateKey = process.env.PrivateKey;
const ethEndPointURL = process.env.EThRopstenEndpoint;

const long = async () => {
  const provider = new Provider(privateKey, ethEndPointURL);
  const web3 = new Web3(provider);
  const networkID = web3.eth.net.getId();

  const contract = web3.eth.Contract(
    CompoundLongingContract.abi,
    CompoundLongingContract.networks[networkID].address
  );

  const init = async () => {
    // contract.methods.init(address , address yield, address z).send({from:})
  };
};
