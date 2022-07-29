// const storageApp = artifacts.require("storageFacet")
const diamondApp = artifacts.require("Diamond")
const diamondCutApp = artifacts.require("DiamondCutFacet")

module.exports = function (deployer, network,accounts) {
    deployer.deploy(diamondCutApp).then(function () {
        const contractOwner = accounts[0];
        return deployer.deploy(diamondApp, contractOwner, diamondCutApp.address);

    })
}