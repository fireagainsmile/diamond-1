pragma solidity ^0.8.0;
import {LibAppStorage} from "./appstorage.sol";

contract storageFacet {
    address private _owner;
    LibAppStorage.appStorage internal apps;
    constructor(){
        _owner = msg.sender;
        apps = LibAppStorage.getAppStorage();
    }

    function setGreeting(string memory _msg)  external onlyOwner {
        apps.greeting = _msg;
    }

    function getGreeting() external view returns(string memory){
        return apps.greeting;
    }

    modifier onlyOwner(){
        require(msg.sender == _owner, "appStorage: owner required");
        _;
    }
}
