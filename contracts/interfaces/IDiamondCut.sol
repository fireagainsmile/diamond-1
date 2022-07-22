pragma solidity ^0.8.0;

interface IDiamondCut {

    enum FacetCutAction{Add, Replace, Remove}
    struct FacetCut{
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    function diamondCut(
        FacetCut[] memory _facets,
        address _init,
        bytes calldata _calldata
    ) external;

    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);
}
