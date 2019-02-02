pragma solidity ^0.5.1;

import "./Item.sol";

import "./meta/Partnerable.sol";
import "./meta/Transferable.sol";

import "./interfaces/Main.sol";

contract Manufacturer is Partnerable, Transferable {
    Main public main;

    string public name;
    string public physicalAddress;
    string public registrationNumber;

    address[] public vendors;
    address[] public serviceCenters;
    address[] public pendingItems;

    mapping (address => bool) isInVendors;
    mapping (address => bool) isInServiceCenters;
    mapping (address => bool) isPendingItem;



    constructor (address _main, address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        main = Main(_main);
        ownerID = _ownerID;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Getters



    function getInfo () view public returns (string memory, string memory, string memory) {
        return (name, physicalAddress, registrationNumber);
    }

    function getVendors () view public returns (address[] memory) {
        return vendors;
    }

    function getServiceCenters () view public returns (address[] memory) {
        return vendors;
    }

    function getPendingItems () view public returns (address[] memory) {
        return pendingItems;
    }



// Public



    function createItem (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) onlyOwner public returns (address) {
        address newItem = address(new Item(address(main), _serial, _info, _warrantyPeriod, _warrantyTerms));
        main.registerItem(newItem);
        addPendingItem(newItem);
        return newItem;
    }

    function setVendorToItem (address vID, address iID) onlyOwner public {
        Main.ContractType cType = main.contractType(vID);
        require((cType == Main.ContractType.VENDOR), "Wrong contract type");

        Item iInstance = Item(iID);
        iInstance.setVendor(vID);
        removePendingItem(iID);
    }

    function activateWarranty (address iID) onlyOwner public {
        Item iInstance = Item(iID);
        iInstance.activateWarranty();
    }



// Internal



    function addSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.VENDOR, "Wrong contract type");
        }
    }
    function removeSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.VENDOR, "Wrong contract type");
        }
    }

    function addReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.VENDOR, "Wrong contract type");
        }
    }
    function removeReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.VENDOR, "Wrong contract type");
        }
    }

    function addCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

            if (cType == Main.ContractType.VENDOR) { addVendor(_id); }
            else if (cType == Main.ContractType.SERVICE_CENTER) { addServiceCenter(_id); }
        }  else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.VENDOR, "Wrong contract type");
            for (uint i = 0; i < req.objs.length; i++) {
                setVendorToItem(_id, req.objs[i]);
            }
        }
    }
    function removeCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

            if (cType == Main.ContractType.VENDOR) { removeVendor(_id); }
            else if (cType == Main.ContractType.SERVICE_CENTER) { removeServiceCenter(_id); }
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            revert("Cannot cancel completed transfer");
        }
    }



    function addPendingItem (address iID) internal { addAddress(pendingItems, isPendingItem, iID); }
    function removePendingItem (address iID) internal { removeAddress(pendingItems, isPendingItem, iID); }

    function addVendor (address vID) internal { addAddress(vendors, isInVendors, vID); }
    function removeVendor (address vID) internal { removeAddress(vendors, isInVendors, vID); }

    function addServiceCenter (address scID) internal { addAddress(serviceCenters, isInServiceCenters, scID); }
    function removeServiceCenter (address scID) internal { removeAddress(serviceCenters, isInServiceCenters, scID); }



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
