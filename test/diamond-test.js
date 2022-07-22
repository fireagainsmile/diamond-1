const StorageFacet = artifacts.require("storageFacet")
const DiamondContract = artifacts.require("Diamond")

contract("Diamond", (accounts) =>{
    it("it has been deployed successfully", async () =>{
        const storageApp = await  StorageFacet.deployed();
        console.log(storageApp.address);
        assert(storageApp, "contract not deployed");
    })
})

contract("DiamondContract", (accounts) => {
    it("it has been deployed successfully", async () => {
        //owner address && contract address
        const storageApp = await  StorageFacet.deployed();
        const contractOwner = accounts[0];

        const diamondApp = await DiamondContract.deployed(contractOwner, storageApp.address);

        assert(diamondApp, "contract not deployed");
    })
})