pragma solidity ^0.8.0;

library  LibAppStorage {

    bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.app.storage");
    struct appStorage {
        string greeting;
    }

    function getAppStorage() internal pure returns(appStorage storage apps){
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly{
            apps.slot := position
        }
    }

}
