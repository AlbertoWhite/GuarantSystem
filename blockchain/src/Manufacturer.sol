pragma solidity ^0.5.1;

import "./Item.sol";

import "./meta/Organization.sol";

import "./interfaces/MainInterface.sol";

contract Manufacturer is Organization {
    MainInterface public main;

    address[] public vendors;
    address[] public serviceCenters;
    address[] public pendingItems;

    mapping (address => bool) isInVendors;
    mapping (address => bool) isInServiceCenters;
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

    function getVendors () view public returns (address[] memory) {
        return vendors;
    }
    
    function getServiceCenters () view public returns (address[] memory) {
        return serviceCenters;
    }
    
    function getPendingItems () view public returns (address[] memory) {
        return pendingItems;
    }



// Public



    function createItem (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) onlyOwner public returns (address) {
        Item newItem = new Item(address(main), _serial, _info, _warrantyPeriod, _warrantyTerms);
        addAddress(pendingItems, isPendingItem, address(newItem));
        return (address(newItem));
    }

    function setVendorToItem (address vID, address iID) onlyOwner public {
        MainInterface.ContractType cType = main.contractType(vID);
        require((cType == MainInterface.ContractType.VENDOR), "Wrong contract type");

        Item iInstance = Item(iID);
        iInstance.setVendor(vID);
        removeAddress(pendingItems, isPendingItem, iID);
    }

    function activateWarranty (address iID) onlyOwner public {
        Item iInstance = Item(iID);
        iInstance.activateWarranty();
    }



// Internal



    function addSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(((cType == MainInterface.ContractType.VENDOR) || (cType == MainInterface.ContractType.SERVICE_CENTER)), "Wrong contract type");
        }
    }
    function removeSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(((cType == MainInterface.ContractType.VENDOR) || (cType == MainInterface.ContractType.SERVICE_CENTER)), "Wrong contract type");
        }
    }

    function addReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(((cType == MainInterface.ContractType.VENDOR) || (cType == MainInterface.ContractType.SERVICE_CENTER)), "Wrong contract type");
        }
    }
    function removeReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(((cType == MainInterface.ContractType.VENDOR) || (cType == MainInterface.ContractType.SERVICE_CENTER)), "Wrong contract type");
        }
    }

    function addCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(((cType == MainInterface.ContractType.VENDOR) || (cType == MainInterface.ContractType.SERVICE_CENTER)), "Wrong contract type");

            if (cType == MainInterface.ContractType.VENDOR) { addAddress(vendors, isInVendors, _id); }
            else if (cType == MainInterface.ContractType.SERVICE_CENTER) { addAddress(serviceCenters, isInServiceCenters, _id); }
        }
    }
    function removeCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            MainInterface.ContractType cType = main.contractType(_id);
            require(((cType == MainInterface.ContractType.VENDOR) || (cType == MainInterface.ContractType.SERVICE_CENTER)), "Wrong contract type");

            if (cType == MainInterface.ContractType.VENDOR) { removeAddress(vendors, isInVendors, _id); }
            else if (cType == MainInterface.ContractType.SERVICE_CENTER) { removeAddress(serviceCenters, isInServiceCenters, _id); }
        }
    }


    function addAddress (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(!map[aID], "Already exists");

        array.push(aID);
        map[aID] = true;
    }

    function removeAddress (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(map[aID], "Not found");

        for (uint i = 0; i < array.length; i++) {
            if (array[i] == aID) {
                array[i] = array[array.length - 1];
                delete array[array.length - 1];
                array.length--;
            }
        }
        map[aID] = false;
    }
}
