const tokenLong = artifacts.require("CompoundTokenLong");

module.exports = function (deployer) {
  deployer.deploy(tokenLong);
};
