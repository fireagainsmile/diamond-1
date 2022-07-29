const DiamondCutApp = artifacts.require("DiamondCutFacet")
const DiamondContract = artifacts.require("Diamond")
const DiamondLoupeContract = artifacts.require("DiamondLoupeFacet")
const StorageFacet = artifacts.require("storageFacet")

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
        // const storageApp = await  StorageFacet.deployed();
        const contractOwner = accounts[0];
        const diamondCutApp = DiamondCutApp.deployed();

        const diamondApp = await DiamondContract.deployed(contractOwner, diamondCutApp.address);

        assert(diamondApp, "contract not deployed");
        // const diamondLoupeContract = new web3.eth.Contract(DiamondLoupeContract.abi, diamondApp.address);

        const response = await diamondApp.selectorLength();

        // const facetAddress = await diamondLoupeApp.facetAddresses();
        console.log("facetAddresses:", response);

        const names = await diamondApp.allSelectors();
        console.log("all selectors:", names);

    })
})
