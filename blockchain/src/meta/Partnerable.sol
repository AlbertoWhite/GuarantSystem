pragma solidity ^0.5.1;

import "./meta/Requestable.sol";

contract Partnerable is Requestable {



// Public



    function requestPartnership (address pID) onlyOwner public {
        RequestType Type = RequestType.PARTNERSHIP;
        address[] memory objs;
        Request memory req = createRequest(Type, objs);
        request(pID, req);
    }

    function acceptPartnership (address pID) onlyOwner public {
        RequestType Type = RequestType.PARTNERSHIP;
        address[] memory objs;
        Request memory req = createRequest(Type, objs);
        acceptRequest(pID, req);
    }

    function declinePartnership (address pID) onlyOwner public {
        RequestType Type = RequestType.PARTNERSHIP;
        address[] memory objs;
        Request memory req = createRequest(Type, objs);
        declineRequest(pID, req);
    }

    function revertPartnership (address pID) onlyOwner public {
        RequestType Type = RequestType.PARTNERSHIP;
        address[] memory objs;
        Request memory req = createRequest(Type, objs);
        revertRequest(pID, req);
    }

    function cancelPartnership (address pID) public {
        RequestType Type = RequestType.PARTNERSHIP;
        address[] memory objs;
        Request memory req = createRequest(Type, objs);
        cancelCompletedRequest(pID, req);
    }

}

