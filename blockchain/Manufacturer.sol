pragma solidity ^0.5.1;

import "./Item.sol";
import "./Vendor.sol";
import "./ServiceCenter.sol";


contract Manufacturer {
    address public id = address(this);
    address private ownerID;
    string public name;
    string public physicalAddress;
    string public registrationNumber;

    address[] public vendors;
    address[] public serviceCenters;
    address[] public receivedVendors;
    address[] public receivedServiceCenters;
    address[] public requestedVendors;
    address[] public requestedServiceCenters;
    address[] public pendingItems;



    mapping (address => bool) isVendor;
    mapping (address => bool) isServiceCenter;
    mapping (address => bool) isReceivedVendor;
    mapping (address => bool) isReceivedServiceCenter;
    mapping (address => bool) isRequestedVendor;
    mapping (address => bool) isRequestedServiceCenter;
    mapping (address => bool) isPendingItem;



    constructor (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        ownerID = msg.sender;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Public



    function createItem (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) onlyOwner public {
        Item newItem = new Item(_serial, _info, _warrantyPeriod, _warrantyTerms);
        _addPendingItem(address(newItem));
    }

    function addVendor (address vID) onlyOwner public {
        if (isReceivedVendor[vID] == true) {
            _addVendor(vID);
            _removeReceivedVendor(vID);
        } else {
            _addRequestedVendor(vID);
        }

        Vendor vInstance = Vendor(vID);
        vInstance.receiveManufacturer();
    }

    function receiveVendor () public {
        address vID = msg.sender;
        require(isReceivedVendor[vID] == false, "Partnership request has already been sent");

        if (isRequestedVendor[vID] == true) {
            _addVendor(vID);
            _removeRequestedVendor(vID);
        } else {
            _addReceivedVendor(vID);
        }
    }

    function removeVendor (address vID) onlyOwnerOrVendor public {
        require((msg.sender == ownerID) || (msg.sender == vID), "Not enough permissions");
        require(isVendor[vID] == true, "No such vendor");

        _removeVendor(vID);

        Vendor vInstance = Vendor(vID);
        vInstance.removeManufacturer(id);
    }

    function addServiceCenter (address scID) onlyOwner public {
        if (isReceivedServiceCenter[scID] == true) {
            _addServiceCenter(scID);
            _removeReceivedServiceCenter(scID);
        } else {
            ServiceCenter scInstance = ServiceCenter(scID);
            scInstance.receiveManufacturer();

            _addRequestedServiceCenter(scID);
        }
    }

    function receiveServiceCenter () public {
        address scID = msg.sender;
        require(isReceivedServiceCenter[scID] == false, "Partnership request has already been sent");

        if (isRequestedServiceCenter[scID] == true) {
            _addServiceCenter(scID);
            _removeRequestedServiceCenter(scID);
        } else {
            _addReceivedServiceCenter(scID);
        }
    }

    function removeServiceCenter (address scID) onlyOwnerOrServiceCenter public {
        require((msg.sender == ownerID) || (msg.sender == scID), "Not enough permissions");
        require(isServiceCenter[scID] == true, "No such service center");

        _removeServiceCenter(scID);

        ServiceCenter scInstance = ServiceCenter(scID);
        scInstance.removeManufacturer(id);
    }



// Internal



    function _removeFromAddressArray (address[] storage array, address value) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
              array[i] = array[array.length - 1];
              delete array[array.length - 1];
              array.length = array.length - 1;
            }
        }
    }

    function _addTo (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(map[aID] == false, "Already exists");

        array.push(aID);
        map[aID] = true;
    }

    function _removeFrom (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(map[aID] == true, "Not found");

        _removeFromAddressArray(array, aID);
        map[aID] = false;
    }


    function _addPendingItem (address iID) internal { _addTo(pendingItems, isPendingItem, iID); }
    function _removePendingItem (address iID) internal { _removeFrom(pendingItems, isPendingItem, iID); }

    function _addVendor (address vID) internal { _addTo(vendors, isVendor, vID); }
    function _removeVendor (address vID) internal { _removeFrom(vendors, isVendor, vID); }

    function _addServiceCenter (address scID) internal { _addTo(serviceCenters, isServiceCenter, scID); }
    function _removeServiceCenter (address scID) internal { _removeFrom(serviceCenters, isServiceCenter, scID); }

    function _addReceivedVendor (address vID) internal { _addTo(receivedVendors, isReceivedVendor, vID); }
    function _removeReceivedVendor (address vID) internal { _removeFrom(receivedVendors, isReceivedVendor, vID); }

    function _addReceivedServiceCenter (address scID) internal { _addTo(receivedServiceCenters, isReceivedServiceCenter, scID); }
    function _removeReceivedServiceCenter (address scID) internal { _removeFrom(receivedServiceCenters, isReceivedServiceCenter, scID); }

    function _addRequestedVendor (address vID) internal { _addTo(requestedVendors, isRequestedVendor, vID); }
    function _removeRequestedVendor (address vID) internal { _removeFrom(requestedVendors, isRequestedVendor, vID); }

    function _addRequestedServiceCenter (address scID) internal { _addTo(requestedServiceCenters, isRequestedServiceCenter, scID); }
    function _removeRequestedServiceCenter (address scID) internal { _removeFrom(requestedServiceCenters, isRequestedServiceCenter, scID); }



// Modifiers



    modifier onlyOwner {
        require(msg.sender == ownerID, "Only owner can call this function");
        _;
    }

    modifier onlyOwnerOrVendor {
        require(((msg.sender == ownerID) || (isVendor[msg.sender] == true)), "Only owner or partner vendor can call this function");
        _;
    }

    modifier onlyOwnerOrServiceCenter {
        require(((msg.sender == ownerID) || (isServiceCenter[msg.sender] == true)), "Only owner or partner service center can call this function");
        _;
    }
}

