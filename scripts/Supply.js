import CompoundLongingContract from "../build/CompoundLonging.json";
const Web3 = require("web3");
const Provider = require("@truffle/hdwallet-provider");
const address = "somethjdka sdkabk";
const privateKey = "akbdkahwnajwkawbdkjha";
const ethEndPointURL = "aaksdbkandbawkdba";

const supply = async () => {
  const provider = new Provider(privateKey, ethEndPointURL);
  const web3 = new Web3(provider);
  const networkID = web3.eth.net.getId();

  const constract = web3.eth.Contract(
    CompoundLongingContract.abi,
    CompoundLongingContract.networks[networkID].address
  );
};
