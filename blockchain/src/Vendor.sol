pragma solidity ^0.5.1;

import "./meta/Organization.sol";

import "./interfaces/MainInterface.sol";
import "./interfaces/ItemInterface.sol";

contract Vendor is Organization {
    MainInterface public main;

    address[] public manufacturers;
    address[] public pendingItems;

    mapping (address => bool) isInManufacturers;
    mapping (address => bool) isPendingItem;



    constructor (address _main, address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        main = MainInterface(_main);
        ownerID = _ownerID;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Getters



    function getInfo () view public returns (string memory, string memory, string memory) {
        return (name, physicalAddress, registrationNumber);
    }

    function getManufacturers () view public returns (address[] memory) {
        return manufacturers;
    }
    
    function getPendingItems () view public returns (address[] memory) {
        return pendingItems;
    }
    
    
    
// Public



    function setOwnerToItem (address uID, address iID) onlyOwner public {
        MainInterface.ContractType cType = main.contractType(uID);
        require((cType == MainInterface.ContractType.USER), "Wrong contract type");

        ItemInterface iInstance = ItemInterface(iID);
        iInstance.setOwner(uID);
        removePendingItem(iID);
    }

    function activateWarranty (address iID) onlyOwner public {
        ItemInterface iInstance = ItemInterface(iID);
        iInstance.activateWarranty();
    }



// Internal



    function addSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(cType == MainInterface.ContractType.MANUFACTURER, "Wrong contract type");
        }
    }
    function removeSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(cType == MainInterface.ContractType.MANUFACTURER, "Wrong contract type");
        }
    }

    function addReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(cType == MainInterface.ContractType.MANUFACTURER, "Wrong contract type");
        }
    }
    function removeReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(cType == MainInterface.ContractType.MANUFACTURER, "Wrong contract type");
        }
    }

    function addCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(cType == MainInterface.ContractType.MANUFACTURER, "Wrong contract type");

            addManufacturer(_id);
        }
    }
    function removeCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(cType == MainInterface.ContractType.MANUFACTURER, "Wrong contract type");

            removeManufacturer(_id);
        }
    }



    function addPendingItem (address iID) internal { addAddress(pendingItems, isPendingItem, iID); }
    function removePendingItem (address iID) internal { removeAddress(pendingItems, isPendingItem, iID); }

    function addManufacturer (address mID) internal { addAddress(manufacturers, isInManufacturers, mID); }
    function removeManufacturer (address mID) internal { removeAddress(manufacturers, isInManufacturers, mID); }



    function addAddress (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(!map[aID], "Already exists");

        array.push(aID);
        map[aID] = true;
    }

    function removeAddress (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(map[aID], "Not found");

        removeFromAddressArray(array, aID);
        map[aID] = false;
    }

    function removeFromAddressArray (address[] storage array, address value) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
              array[i] = array[array.length - 1];
              delete array[array.length - 1];
              array.length--;
            }
        }
    }
}
