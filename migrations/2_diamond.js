const storageApp = artifacts.require("storageFacet")
const diamondApp = artifacts.require("Diamond")

module.exports = function (deployer, accounts) {
    const storageContract = deployer.deploy(storageApp);
    console.log(storageContract.address);
    const contractOwner = accounts[0];
    // deployer.deploy(contractOwner, storageContract.address);
    deployer.deploy(diamondApp, accounts[0], storageContract.address);
}