pragma solidity ^0.5.1;

import "./Main.sol";
import "./Item.sol";
import "./Vendor.sol";
import "./ServiceCenter.sol";



contract Manufacturer {
    Main main;
    enum ContractType {NON_AUTHORIZED, ITEM, USER, MANUFACTURER, VENDOR, SERVICE_CENTER}

    address public id = address(this);
    address private ownerID;
    string public name;
    string public physicalAddress;
    string public registrationNumber;

    address[] public vendors;
    address[] public serviceCenters;
    address[] public receivedPartnerships;
    address[] public requestedPartnerships;
    address[] public pendingItems;



    mapping (address => bool) isInVendors;
    mapping (address => bool) isInServiceCenters;
    mapping (address => bool) isReceivedPartnership;
    mapping (address => bool) isRequestedPartnership;
    mapping (address => bool) isPendingItem;



    constructor (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        main = Main(msg.sender);
        ownerID = _ownerID;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Public



    function createItem (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) onlyOwner public {
        Item newItem = new Item(_serial, _info, _warrantyPeriod, _warrantyTerms);
        _addPendingItem(address(newItem));
    }

    function requestPartnership (address pID) onlyOwner public {
        if (isReceivedPartnership[pID] == true) {
            _addPartner(pID);
            _removeReceivedPartnership(pID);
        } else {
            _addRequestedPartnership(pID);
        }

        _requestPartnership(pID);
    }

    function receivePartnershipRequest () public {
        address pID = msg.sender;
        require(isReceivedPartnership[pID] == false, "Partnership request has already been sent");

        if (isRequestedPartnership[pID] == true) {
            _addPartner(pID);
            _removeRequestedPartnership(pID);
        } else {
            _addReceivedPartnership(pID);
        }
    }

    function cancelPartnership (address pID) onlyOwnerOrPartner public {
        require((msg.sender == ownerID) || (msg.sender == pID), "Not enough permissions");
        require((isInVendors[pID] == true) || (isInServiceCenters[pID] == true), "No such partner");

        _removePartner(pID);

        _requestCancelPartnership(pID);
    }



// Internal



    function _addPartner (address pID) internal {
        ContractType pType = main.getContractType(pID);
        require((pType == ContractType.Vendor) || (pType == ContractType.SERVICE_CENTER));

        if (pType == ContractType.VENDOR) { _addVendor(pID); }
        else if (pType == ContractType.SERVICE_CENTER) { _addServiceCenter(pID); }
    }

    function _removePartner (address pID) internal {
        ContractType pType = main.getContractType(pID);
        require((pType == ContractType.Vendor) || (pType == ContractType.SERVICE_CENTER));

        if (pType == ContractType.VENDOR) { _removeVendor(pID); }
        else if (pType == ContractType.SERVICE_CENTER) { _removeServiceCenter(pID); }
    }

    function _requestPartnership (address pID) internal {
        ContractType pType = main.getContractType(pID);
        require((pType == ContractType.Vendor) || (pType == ContractType.SERVICE_CENTER));

        if (pType == ContractType.VENDOR) {
            Vendor vInstance = Vendor(pID);
            vInstance.receivePartnershipRequest();
        }
        else if (pType == ContractType.SERVICE_CENTER) {
            ServiceCenter scInstance = ServiceCenter(pID);
            scInstance.receivePartnershipRequest();
        }
    }

    function _requestCancelPartnership (address pID) internal {
        ContractType pType = main.getContractType(pID);
        require((pType == ContractType.Vendor) || (pType == ContractType.SERVICE_CENTER));

        if (pType == ContractType.VENDOR) {
            Vendor vInstance = Vendor(pID);
            vInstance.cancelPartnership(id);
        }
        else if (pType == ContractType.SERVICE_CENTER) {
            ServiceCenter scInstance = ServiceCenter(pID);
            scInstance.cancelPartnership(id);
        }
    }

    function _addPendingItem (address iID) internal { _addTo(pendingItems, isPendingItem, iID); }
    function _removePendingItem (address iID) internal { _removeFrom(pendingItems, isPendingItem, iID); }

    function _addVendor (address vID) internal { _addTo(vendors, isInVendors, vID); }
    function _removeVendor (address vID) internal { _removeFrom(vendors, isInVendors, vID); }

    function _addServiceCenter (address scID) internal { _addTo(serviceCenters, isInServiceCenters, scID); }
    function _removeServiceCenter (address scID) internal { _removeFrom(serviceCenters, isInServiceCenters, scID); }

    function _addRequestedPartnership (address pID) internal { _addTo(requestedPartnerships, isRequestedPartnership, pID); }
    function _removeRequestedPartnership (address pID) internal { _removeFrom(requestedPartnerships, isRequestedPartnership, pID); }

    function _addReceivedPartnership (address pID) internal { _addTo(receivedPartnerships, isReceivedPartnership, pID); }
    function _removeReceivedPartnership (address pID) internal { _removeFrom(receivedPartnerships, isReceivedPartnership, pID); }

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

    function _removeFromAddressArray (address[] storage array, address value) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
              array[i] = array[array.length - 1];
              delete array[array.length - 1];
              array.length = array.length - 1;
            }
        }
    }



// Modifiers



    modifier onlyOwner {
        require(msg.sender == ownerID, "Only owner can call this function");
        _;
    }

    modifier onlyOwnerOrPartner {
        require(((msg.sender == ownerID) || (isInVendors[msg.sender] == true) || (isInServiceCenters[msg.sender] == true)), "Only owner or partner vendor can call this function");
        _;
    }
}

