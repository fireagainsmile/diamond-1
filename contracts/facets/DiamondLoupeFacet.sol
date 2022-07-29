pragma solidity ^0.8.0;

import { LibDiamond } from "../libraries/LibDiamond.sol";
import {IDiamondLoupe } from "../interfaces/IDiamondLoupe.sol";
import {IERC165} from "../interfaces/IERC165.sol";


contract DiamondLoupeFacet is IDiamondLoupe, IERC165 {
    // Diamond Loupe Functions
    ////////////////////////////////////////////////////////////////////
    /// These functions are expected to be called frequently by tools.
    //
    // struct Facet {
    //     address facetAddress;
    //     bytes4[] functionSelectors;
    // }
    /// @notice Gets all facets and their selectors.
    /// @return facets_ Facet

    function facets() external  view override returns (Facet[] memory facets_){
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 selectorCount = ds.selectors.length;
        facets_ = new Facet[](selectorCount);
        uint8[] memory numFacetSelectors = new uint8[](selectorCount);

        uint256 numFacets;

        for(uint256 selectorIndex;selectorIndex < selectorCount; selectorIndex++){
            bytes4 selector = ds.selectors[selectorIndex];

            address facetAddress = ds.facetAddressAndSelectorPosition[selector].facetAddress;
            bool continueLoop = false;
            for(uint256 facetIndex; facetIndex< numFacets; facetIndex++){
                if(facets_[facetIndex].facetAddress == facetAddress){
                    facets_[facetIndex].functionSelectors[numFacetSelectors[facetIndex]] = selector;
                    require(numFacetSelectors[facetIndex] < 255);
                    numFacetSelectors[facetIndex] ++;
                    continueLoop = true;
                    break;
                }
            }

            if(continueLoop){
                continueLoop = false;
                continue;
            }

            facets_[numFacets].facetAddress = facetAddress;
            facets_[numFacets].functionSelectors = new bytes4[](selectorCount);
            facets_[numFacets].functionSelectors[0] = selector;
            numFacetSelectors[numFacets] = 1;
            numFacets++;
        }

        for(uint256 facetIndex; facetIndex < numFacets; facetIndex++){
            uint256 numSelectors = numFacetSelectors[facetIndex];
            bytes4[] memory selectors = facets_[facetIndex].functionSelectors;
            //setting the numbers of selectors
            assembly{
                mstore(selectors, numSelectors)
            }

        }
        //setting the number of facets;
        assembly{
            mstore(facets_, numFacets)
        }

    }

    function facetFunctionSelectors(address _facetAddress) external override view returns(bytes4[] memory selectors_){
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 selectorCount = ds.selectors.length;
        uint256 numSelectors;
        selectors_ = new bytes4[](selectorCount);
        for(uint256 selectorIndex; selectorIndex < selectorCount; selectorIndex++){
            bytes4 selector = ds.selectors[selectorIndex];
            if (ds.facetAddressAndSelectorPosition[selector].facetAddress == _facetAddress){
                selectors_[numSelectors] = selector;
                numSelectors ++;
            }

        }
        assembly{
            mstore(selectors_, numSelectors)
        }

    }

    function facetAddresses() external override view returns(address[] memory facetAddress_){
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 selectorCount = ds.selectors.length;
        uint256 facetCount;
        facetAddress_ = new address[](selectorCount);
        for(uint256 selectorIndex; selectorIndex < selectorCount; selectorIndex++){
            bytes4 selector = ds.selectors[selectorIndex];
            address selectorAddress = ds.facetAddressAndSelectorPosition[selector].facetAddress;
            bool continueLoop = false;
            for(uint256 facetIndex; facetIndex < facetCount; facetIndex ++){
                if(facetAddress_[facetIndex] == selectorAddress){
                    continueLoop = true;
                    break;
                }
            }
            if(continueLoop){
                continueLoop = false;
                break;
            }
            facetAddress_[facetCount] = selectorAddress;
            facetCount ++;
        }
        assembly{
            mstore(facetAddress_, facetCount)
        }
    }

    function facetAddress(bytes4 _functionSelectors) external override view returns(address facetAddress_){
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        facetAddress_ = ds.facetAddressAndSelectorPosition[_functionSelectors].facetAddress;
    }

    function supportsInterface(bytes4 _interfaceId) external override view returns(bool ){
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        return ds.supportedInterfaces[_interfaceId];
    }
}
