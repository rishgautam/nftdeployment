const Token = artifacts.require("NFT_token");

module.exports = function (deployer) {
  deployer.deploy(Token,"Heart","Heart");
};