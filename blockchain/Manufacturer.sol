pragma solidity ^0.5.1;

import "./Requestable.sol";
import "./Organization.sol";

import "./Main.sol";
import "./Item.sol";


contract Manufacturer is Organization {
    Main public main;

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



// Public



    function createItem (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) onlyOwner public returns (address) {
        Item newItem = new Item(address(main), _serial, _info, _warrantyPeriod, _warrantyTerms);
        addPendingItem(address(newItem));
        return (address(newItem));
    }

    function setVendorToItem (address vID, address iID) onlyOwner public {
        Main.ContractType cType = main.getContractType(vID);
        require((cType == Main.ContractType.VENDOR), "Wrong contract type");

        Item iInstance = Item(iID);
        iInstance.setVendor(vID);
    }

    function activateWarranty (address iID) onlyOwner public {
        Item iInstance = Item(iID);
        iInstance.activateWarranty();
    }



// Internal



    function addSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.getContractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");
        }
    }
    function removeSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.getContractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");
        }
    }

    function addReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.getContractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");
        }
    }
    function removeReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.getContractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");
        }
    }

    function addCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.getContractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

            if (cType == Main.ContractType.VENDOR) { addVendor(_id); }
            else if (cType == Main.ContractType.SERVICE_CENTER) { addServiceCenter(_id); }
        }
    }
    function removeCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.getContractType(_id);
            require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

            if (cType == Main.ContractType.VENDOR) { removeVendor(_id); }
            else if (cType == Main.ContractType.SERVICE_CENTER) { removeServiceCenter(_id); }
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
