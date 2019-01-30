pragma solidity ^0.5.1;

import "./Main.sol";
import "./Manufacturer.sol";

contract Vendor {
    Main main;

    address public id = address(this);
    address private ownerID;
    string public name;
    string public physicalAddress;
    string public registrationNumber;

    address[] public manufacturers;
    address[] public receivedPartnerships;
    address[] public requestedPartnerships;
    address[] public pendingItems;



    mapping (address => bool) isInManufacturers;
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
        require((isInManufacturers[pID] == true), "No such partner");

        _removePartner(pID);

        _requestCancelPartnership(pID);
    }



// Internal



    function _addPartner (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        _addManufacturer(pID);
    }

    function _removePartner (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        _removeManufacturer(pID);
    }

    function _requestPartnership (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Manufacturer mInstance = Manufacturer(pID);
        mInstance.receivePartnershipRequest();
    }

    function _requestCancelPartnership (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Manufacturer mInstance = Manufacturer(pID);
        mInstance.cancelPartnership(id);
    }

    function _addPendingItem (address iID) internal { _addTo(pendingItems, isPendingItem, iID); }
    function _removePendingItem (address iID) internal { _removeFrom(pendingItems, isPendingItem, iID); }

    function _addManufacturer (address mID) internal { _addTo(manufacturers, isInManufacturers, mID); }
    function _removeManufacturer (address mID) internal { _removeFrom(manufacturers, isInManufacturers, mID); }

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
        require(((msg.sender == ownerID) || (isInManufacturers[msg.sender] == true)), "Only owner or partner can call this function");
        _;
    }
}
