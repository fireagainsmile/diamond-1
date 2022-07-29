const storageApp = artifacts.require("storageFacet")

module.exports = function (deployer, network, accounts) {
    deployer.deploy(storageApp);
}