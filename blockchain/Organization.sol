pragma solidity ^0.5.1;



contract Organization {
    address public id = address(this);
    address private ownerID;
    string public name;
    string public physicalAddress;
    string public registrationNumber;

    address[] public receivedPartnerships;
    address[] public requestedPartnerships;

    mapping (address => bool) isInPartnership;
    mapping (address => bool) isReceivedPartnership;
    mapping (address => bool) isRequestedPartnership;



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
        require(isInPartnership[pID] == true, "No such partner");

        _removePartner(pID);

        _requestCancelPartnership(pID);
    }



// Internal



    function _addPartner (address pID) internal {}

    function _removePartner (address pID) internal {}

    function _requestPartnership (address pID) internal {}

    function _requestCancelPartnership (address pID) internal {}

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
        require(((msg.sender == ownerID) || (isInPartnership[msg.sender] == true)), "Only owner or partner can call this function");
        _;
    }
}

