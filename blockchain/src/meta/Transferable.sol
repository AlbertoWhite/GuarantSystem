pragma solidity ^0.5.1;

import "./meta/Requestable.sol";

contract Transferable is Requestable {



// Public



    function requestTransfer (address pID, address[] memory _objs) onlyOwner public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        request(pID, req);
    }

    function acceptTransfer (address pID, address[] memory _objs) onlyOwner public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        acceptRequest(pID, req);
    }

    function declineTransfer (address pID, address[] memory _objs) onlyOwner public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        declineRequest(pID, req);
    }

    function revertTransfer (address pID, address[] memory _objs) onlyOwner public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        revertRequest(pID, req);
    }

    function cancelTransfer (address pID, address[] memory _objs) public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        cancelCompletedRequest(pID, req);
    }
}

