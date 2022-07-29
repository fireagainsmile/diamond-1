pragma solidity ^0.8.0;

import {LibDiamond} from "./libraries/LibDiamond.sol";
import {IDiamondCut} from "./interfaces/IDiamondCut.sol";



contract Diamond {
    // @param contractOwner is the contract owner
    constructor(address contractOwner, address diamondAppAddress) payable {
        LibDiamond.setContractOwner(contractOwner);

        // Add the diamondCut external function from the diamondCutFacet
        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        bytes4[] memory functionSelectors =new bytes4[](1);
        functionSelectors[0] = IDiamondCut.diamondCut.selector;
        cut[0] = IDiamondCut.FacetCut({facetAddress: diamondAppAddress, action: IDiamondCut.FacetCutAction.Add, functionSelectors:functionSelectors
        });
        LibDiamond.diamondCut(cut, address(0), "");

    }

    // @notice
    // below functions are for test purpose
    function selectorLength() external view returns(uint256 selectorLength_){
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        selectorLength_ = ds.selectors.length;
    }

    function allSelectors() external view returns (bytes4[] memory allSelectors_){
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 selectorLength_ = ds.selectors.length;
        allSelectors_ = new bytes4[](selectorLength_);
        for(uint256 index; index< selectorLength_; index++){
            allSelectors_[index]=ds.selectors[index];
        }
    }


    fallback() external payable{
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        assembly{
            ds.slot := position
        }

        address facet = ds.facetAddressAndSelectorPosition[msg.sig].facetAddress;
        require(facet != address(0), "Diamond: Function does not exist");
        assembly{
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default{
                return(0, returndatasize())
            }
        }

    }

    receive() external payable{}
}
