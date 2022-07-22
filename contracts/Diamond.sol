pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import "../libraries/LibDiamond.sol";
import {IDiamondCut} from "../interfaces/IDiamondCut.sol";


contract Diamond {
    constructor(address contractOwner, address _diamondFacetCut) payable {
        LibDiamond.setContractOwner(contractOwner);

    }
}
