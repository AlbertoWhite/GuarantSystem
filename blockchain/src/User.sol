pragma solidity ^0.5.1;

import "./interfaces/Main.sol";
import "./interfaces/Item.sol";

contract User {
    Main public main;

    address public id = address(this);
    address private ownerID;
    address[] public items;

    constructor (address _main, address _ownerID) public {
        main = Main(_main);
        ownerID = _ownerID;
    }



// Public



    function getItems () view public returns (address[] memory) {
        return items;
    }


    function changeOwner (address uID, address iID) onlyOwner public {
        Main.ContractType cType = main.contractType(uID);
        require((cType == Main.ContractType.USER), "Wrong contract type");

        Item iInstance = Item(iID);
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
