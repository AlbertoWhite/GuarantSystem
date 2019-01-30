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
        require(isRequestedPartnership[pID] == false, "Partnership has already been requested");

        _addRequestedPartnership(pID);
        _sendPartnershipRequest(pID);
    }

    function acceptPartnership (address pID) onlyOwner public {
        require(isReceivedPartnership[pID] == true, "No such request");
        _addPartner(pID);
        _removeReceivedPartnership(pID);
        _sendPartnershipRequest(pID);
    }

    function declinePartnership (address pID) onlyOwner public {
        require(isReceivedPartnership[pID] == true, "No such request");
        _removeReceivedPartnership(pID);
        _sendPartnershipDecline(pID);
    }

    function revertPartnership (address pID) onlyOwner public {
        require(isRequestedPartnership[pID] == true, "No such request");
        _removeRequestedPartnership(pID);
        _sendPartnershipRevert(pID);
    }


    function cancelPartnership (address pID) onlyOwnerOrPartner public {
        require(((msg.sender == ownerID) || (msg.sender == pID)), "Not enough permissions");
        require(isInPartnership[pID] == true, "No such partner");

        _removePartner(pID);

        _sendPartnershipCancel(pID);
    }

    function receivePartnershipRequest () public {
        address pID = msg.sender;
        require(isReceivedPartnership[pID] == false, "Partnership has already been requested");

        if (isRequestedPartnership[pID] == true) {
            _addPartner(pID);
            _removeRequestedPartnership(pID);
        } else {
            _addReceivedPartnership(pID);
        }
    }

    function receivePartnershipDecline () public {
        address pID = msg.sender;
        require(isRequestedPartnership[pID] == true, "Partnership has not been requested");

        _removeRequestedPartnership(pID);
    }

    function receivePartnershipRevert () public {
        address pID = msg.sender;
        require(isReceivedPartnership[pID] == true, "Partnership has not been requested");

        _removeReceivedPartnership(pID);
    }



// Internal


    function _addPartnerMethod (address pID) internal {}
    function _removePartnerMethod (address pID) internal {}

    function _addPartner (address pID) internal {
        isInPartnership[pID] = true;
        _addPartnerMethod(pID);
    }

    function _removePartner (address pID) internal {
        isInPartnership[pID] = false;
        _removePartnerMethod(pID);
    }

    function _sendPartnershipRequest (address pID) internal {
        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipRequest();
    }

    function _sendPartnershipDecline (address pID) internal {
        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipDecline();
    }

    function _sendPartnershipRevert (address pID) internal {
        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipRevert();
    }

    function _sendPartnershipCancel (address pID) internal {
        Organization oInstance = Organization(pID);
        oInstance.cancelPartnership(id);
    }

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
              array.length--;
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

