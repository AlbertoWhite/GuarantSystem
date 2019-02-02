pragma solidity ^0.5.1;

import "./interfaces/MainInterface.sol";
import "./interfaces/ItemInterface.sol";

contract User {
    MainInterface public main;

    address public id = address(this);
    address private ownerID;
    address[] public items;

    constructor (address _main, address _ownerID) public {
        main = MainInterface(_main);
        ownerID = _ownerID;
    }



// Public



    function getItems () view public returns (address[] memory) {
        return items;
    }


    function changeOwner (address uID, address iID) onlyOwner public {
        MainInterface.ContractType cType = main.contractType(uID);
        require((cType == MainInterface.ContractType.USER), "Wrong contract type");

        ItemInterface iInstance = ItemInterface(iID);
        iInstance.changeOwner(uID);
        removeFromAddressArray(items, iID);
    }



// Internal



    function removeFromAddressArray (address[] storage array, address value) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
              array[i] = array[array.length - 1];
              delete array[array.length - 1];
              array.length--;
            }
        }
    }



// Modifiers



    modifier onlyOwner {
        require((msg.sender == ownerID), "Permission denied");
        _;
    }
}
