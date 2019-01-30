pragma solidity ^0.5.1;

import "./Manufacturer.sol";

contract ServiceCenter {
    address public id = address(this);
    address private ownerID;
    string public name;
    string public physicalAddress;
    string public registrationNumber;

    address[] public manufacturers;
    address[] public receivedManufacturers;
    address[] public requestedManufacturers;
    address[] public pendingItems;



    mapping (address => bool) isManufacturer;
    mapping (address => bool) isReceivedManufacturer;
    mapping (address => bool) isRequestedManufacturer;
    mapping (address => bool) isPendingItem;



    constructor (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        ownerID = msg.sender;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Public



    function addManufacturer (address mID) onlyOwner public {
        if (isReceivedManufacturer[mID] == true) {
            _addManufacturer(mID);
            _removeReceivedManufacturer(mID);
        } else {
            Manufacturer mInstance = Manufacturer(mID);
            mInstance.receiveServiceCenter();

            _addRequestedManufacturer(mID);
        }
    }

    function receiveManufacturer () public {
        address mID = msg.sender;
        require(isReceivedManufacturer[mID] == false, "Partnership request has already been sent");

        if (isRequestedManufacturer[mID] == true) {
            _addManufacturer(mID);
            _removeRequestedManufacturer(mID);
        } else {
            _addReceivedManufacturer(mID);
        }
    }

    function removeManufacturer (address mID) onlyOwnerOrManufacturer public {
        require((msg.sender == ownerID) || (msg.sender == mID), "Not enough permissions");
        require(isManufacturer[mID] == true, "No such manufacturer");

        _removeManufacturer(mID);

        Manufacturer mInstance = Manufacturer(mID);
        mInstance.removeServiceCenter(id);
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

    function _addManufacturer (address mID) internal { _addTo(manufacturers, isManufacturer, mID); }
    function _removeManufacturer (address mID) internal { _removeFrom(manufacturers, isManufacturer, mID); }

    function _addReceivedManufacturer (address mID) internal { _addTo(receivedManufacturers, isReceivedManufacturer, mID); }
    function _removeReceivedManufacturer (address mID) internal { _removeFrom(receivedManufacturers, isReceivedManufacturer, mID); }

    function _addRequestedManufacturer (address mID) internal { _addTo(requestedManufacturers, isRequestedManufacturer, mID); }
    function _removeRequestedManufacturer (address mID) internal { _removeFrom(requestedManufacturers, isRequestedManufacturer, mID); }



// Modifiers



    modifier onlyOwner {
        require(msg.sender == ownerID, "Only owner can call this function");
        _;
    }

    modifier onlyOwnerOrManufacturer {
        require(((msg.sender == ownerID) || (isManufacturer[msg.sender] == true)), "Only owner or partner manufacturer can call this function");
        _;
    }
}
