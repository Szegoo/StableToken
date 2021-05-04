const ERC20 = artifacts.require("ERC20");
const Exchange = artifacts.require("Exchange");

module.exports = async function (deployer) {
    await deployer.deploy(ERC20, "StableToken", "STT");

    await deployer.deploy(Exchange, ERC20.address);

    var token = await ERC20.deployed();
    await token.addMinter(Exchange.address);
};