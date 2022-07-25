const storageApp = artifacts.require("storageFacet")
const diamondApp = artifacts.require("Diamond")

module.exports = function (deployer, network,accounts) {
    deployer.deploy(storageApp).then(function () {
        const contractOwner = accounts[0];
        return deployer.deploy(diamondApp, contractOwner, storageApp.address);
    })
}