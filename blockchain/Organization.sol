pragma solidity ^0.5.1;

import "./Requestable.sol";

contract Organization is Requestable {
    string public name;
    string public physicalAddress;
    string public registrationNumber;



// Public



    function requestPartnership (address pID) onlyOwner public {
        Request memory req;
        req.Type = RequestType.PARTNERSHIP;
        request(pID, req);
    }

    function acceptPartnership (address pID) onlyOwner public {
        Request memory req;
        req.Type = RequestType.PARTNERSHIP;
        acceptRequest(pID, req);
    }

    function declinePartnership (address pID) onlyOwner public {
        Request memory req;
        req.Type = RequestType.PARTNERSHIP;
        declineRequest(pID, req);
    }

    function revertPartnership (address pID) onlyOwner public {
        Request memory req;
        req.Type = RequestType.PARTNERSHIP;
        revertRequest(pID, req);
    }

    function cancelPartnership (address pID) public {
        Request memory req;
        req.Type = RequestType.PARTNERSHIP;
        cancelCompletedRequest(pID, req);
    }
}

