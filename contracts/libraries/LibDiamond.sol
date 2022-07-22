pragma solidity ^0.8.0;

import { IDiamondCut } from "../interfaces/IDiamondCut.sol";

library LibDiamond {
    bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.standard.storage");

    struct FacetAddressAndSelectorPosition{
        address facetAddress;
        uint16 selectorPosition;
    }

    struct DiamondStorage{
        mapping(bytes4 => FacetAddressAndSelectorPosition) facetAddressAndSelectorPosition;
        bytes4[] selectors;
        mapping(bytes4 => bool) supportedInterfaces;
        address contractOwner;
    }

    function diamondStorage() internal pure returns(DiamondStorage storage ds){
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly{
            ds.slot := position
        }
    }

    event OwnerShipTransferred(address indexed previousOwner, address indexed newOwner);

    function setContractOwner(address _newOwner) internal {
        DiamondStorage storage ds = diamondStorage();
        address previousOwner = ds.contractOwner;
        ds.contractOwner = _newOwner;
        emit OwnerShipTransferred(previousOwner, _newOwner);
    }

    function contractOwner() internal view returns(address _owner){
        _owner = diamondStorage().contractOwner;
    }

    function enforceIsContractOwner() internal view{
        require(msg.sender == diamondStorage().contractOwner, "LibDiamond: Must be contract Owner");
    }

    event DiamondCut(IDiamondCut.FacetCut[] _diamondCut, address _init, bytes _calldata);


    function diamondCut(
        IDiamondCut.FacetCut[] memory _diamondCut,
        address _init,
        bytes memory _calldata
    ) internal{
        for(uint256 facetIndex; facetIndex < _diamondCut.length; facetIndex++){
            IDiamondCut.FacetCutAction  action = _diamondCut[facetIndex].action;
            if (action == IDiamondCut.FacetCutAction.Add){

            }else if(action == IDiamondCut.FacetCutAction.Replace){

            }else if(action == IDiamondCut.FacetCutAction.Remove){

            }else{

            }
        }
    }

    function addFacetCut(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        require(_facetAddress != address (0), "LibDiamond: Invalid address");
        require(_functionSelectors.length > 0, "LibDiamond: no function selectors");
        DiamondStorage storage ds = diamondStorage();
        uint16 selectorCount =uint16(ds.selectors.length);
        for(uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++){
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = ds.facetAddressAndSelectorPosition[selector].facetAddress;
            require(oldFacetAddress == address (0), "LibDiamond: facet already exist");
            ds.selectors.push(selector);
            ds.facetAddressAndSelectorPosition[selector] = FacetAddressAndSelectorPosition(_facetAddress, selectorCount);
            selectorCount++;
        }
    }

    function replaceFacetCut(address _facetAddress, bytes4[] memory _functionSelectors) internal{
        require(_functionSelectors.length > 0, "LibDiamond: no function selectors");
        require(_facetAddress != address (0), "LibDiamond: nil address");

        DiamondStorage storage ds = diamondStorage();
        for(uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++){
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = ds.facetAddressAndSelectorPosition[selector].facetAddress;
            require(oldFacetAddress!= address (0), "LibDiamond: selector does not exist!");
            require(_facetAddress != oldFacetAddress, "LibDiamond: can't replace function with the same address");
            require(oldFacetAddress != address(this), "LibDiamond: can't replace immutable function");

            ds.facetAddressAndSelectorPosition[selector].facetAddress = _facetAddress;

        }
    }

    // remove facet, update selector index and delete removed selector
    function removeFacetCut(address _facetAddress, bytes4[] memory _functionSelectors) internal{
        require(_functionSelectors.length > 0 ,"LibDiamond: no function selectors");
        DiamondStorage storage ds = diamondStorage();
        uint16 selectorCount = uint16(ds.selectors.length);

        for(uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++){
            bytes4 selector = _functionSelectors[selectorIndex];
            FacetAddressAndSelectorPosition memory facetAddressAndSelectorPosition = ds.facetAddressAndSelectorPosition[selector];
            require(facetAddressAndSelectorPosition.facetAddress != address (0), "LibDiamond: facet does not exist");
            require(facetAddressAndSelectorPosition.facetAddress != address (this), "LibDiamond: can not remove immutable facet");
            selectorCount --;

            if(facetAddressAndSelectorPosition.selectorPosition != selectorCount){
                bytes4 lastSelector = ds.selectors[selectorCount];
                ds.selectors[facetAddressAndSelectorPosition.selectorPosition] = lastSelector;
                ds.facetAddressAndSelectorPosition[lastSelector].selectorPosition = facetAddressAndSelectorPosition.selectorPosition;
            }

            ds.selectors.pop();
            delete ds.facetAddressAndSelectorPosition[selector];


        }
    }


    function initializeDiamondCut(address _init, bytes calldata _calldata) internal{
        if(_init == address (0)){
            require(_calldata.length == 0, "LibDiamond: init address is 0 while calldata is not empty");
        }else{
            require(_calldata.length > 0, "LibDiamond: calldata is empty");
            if (_init == address (this)){
                enforceHasContractCode(_init, "LibDiamond: _init address has no code");
            }
            (bool success, bytes memory error)=_init.delegatecall(_calldata);

            if(!success){
                if(error.length > 0){
                    revert(string(error));
                }else{
                    revert("LibDiamond: _init reverted");
                }
            }
        }

    }

    // enforce address has codes
    function enforceHasContractCode(
        address _contract,
        string memory _errorMsg
    )internal {
        uint256 codeSize;
        assembly{
            codeSize := extcodesize(_contract)
        }
        require(codeSize > 0, _errorMsg);
    }
}
