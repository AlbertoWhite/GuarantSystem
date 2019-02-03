pragma solidity ^0.5.1;

import "./meta/Requestable.sol";

contract Transferable is Requestable {



// Public



    function requestTransfer (address _id, address[] memory _objs) onlyOwner public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        request(_id, req);
    }

    function acceptTransfer (address _id, address[] memory _objs) onlyOwner public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        acceptRequest(_id, req);
    }

    function declineTransfer (address _id, address[] memory _objs) onlyOwner public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        declineRequest(_id, req);
    }

    function revertTransfer (address _id, address[] memory _objs) onlyOwner public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        revertRequest(_id, req);
    }

    function cancelTransfer (address _id, address[] memory _objs) public {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = createRequest(Type, objs);
        cancelCompletedRequest(_id, req);
    }
}

