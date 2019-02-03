pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

contract Requestable {
    address public id = address(this);
    address internal ownerID;

    enum RequestType {NULL, PARTNERSHIP, TRANSFER}

    struct Request {
        RequestType Type;
        address[] objs;
    }

    Request[] internal pendingRequests;
    Request[] internal receivedRequests;
    Request[] internal sentRequests;
    Request[] internal completedRequests;

    mapping (bytes32 => bool) internal isPendingRequest;
    mapping (bytes32 => bool) internal isReceivedRequest;
    mapping (bytes32 => bool) internal isSentRequest;
    mapping (bytes32 => bool) internal isCompletedRequest;
    mapping (address => bool) internal isPendingObj;



// Getters



    function getPendingRequests () view onlyOwner public returns (Request[] memory) { return pendingRequests; }
    function getReceivedRequests () view onlyOwner public returns (Request[] memory) { return receivedRequests; }
    function getSentRequests () view onlyOwner public returns (Request[] memory) { return sentRequests; }
    function getCompletedRequests () view onlyOwner public returns (Request[] memory) { return completedRequests; }



// Public



    function makeRequest (RequestType _Type, address[] memory _objs) onlyOwner internal returns (Request memory) {
        bool pendings = false;
        for (uint i = 0; (0 <= i) && (i < _objs.length);) {
            if (!pendings) {
                if (isPendingObj[_objs[i]]) {
                    pendings = true;
                    i--;
                } else {
                    isPendingObj[_objs[i]] = true;
                    i++;
                }
            } else {
                isPendingObj[_objs[i]] = false;
                i--;
            }
        }
        require(!pendings, "One of the objects is already pending");
        Request memory req = Request(_Type, _objs);
        addRequest(pendingRequests, isPendingRequest, req);
        return req;
    }

    function deletePendingRequest (Request memory req) onlyOwner public {
        removeRequest(pendingRequests, isPendingRequest, req);
        removePendingObjs(req);
    }

    function request (address _id, Request memory req) onlyOwner public {
        require(!isSentRequest[hashRequest(req)], "Request has already been sent");
        if (isReceivedRequest[hashRequest(req)]) {
            acceptRequest(_id, req);
        } else {
            sendRequest(_id, req);
            addSentRequest(_id, req);
        }
    }

    function acceptRequest (address _id, Request memory req) onlyOwner public {
        require(isReceivedRequest[hashRequest(req)], "No such request");
        removeReceivedRequest(_id, req);
        addCompletedRequest(_id, req);
        sendRequest(_id, req);
    }

    function declineRequest (address _id, Request memory req) onlyOwner public {
        require(isReceivedRequest[hashRequest(req)], "No such request");
        removeReceivedRequest(_id, req);
        sendRequestDecline(_id, req);
    }

    function revertRequest (address _id, Request memory req) onlyOwner public {
        require(isSentRequest[hashRequest(req)], "No such request");
        removeSentRequest(_id, req);
        sendRequestRevert(_id, req);
    }

    function cancelCompletedRequest (address _id, Request memory req) public {
        require(((msg.sender == ownerID) || ((msg.sender == _id) && isCompletedRequest[hashRequest(req)])), "Not enough permissions");
        removeCompletedRequest(_id, req);
        sendCompletedRequestCancel(_id, req);
    }



// Internal



    function receiveRequest (RequestType _Type, address[] memory _objs) public {
        Request memory req = Request(_Type, _objs);
        address _id = msg.sender;
        require(!isReceivedRequest[hashRequest(req)], "Request has already been received");

        if (isSentRequest[hashRequest(req)]) {
            removeSentRequest(_id, req);
            addCompletedRequest(_id, req);
        } else {
            addReceivedRequest(_id, req);
        }
    }

    function receiveRequestDecline (RequestType _Type, address[] memory _objs) public {
        Request memory req = Request(_Type, _objs);
        address _id = msg.sender;
        require(isSentRequest[hashRequest(req)], "Request has not been sent");
        removeSentRequest(_id, req);
    }

    function receiveRequestRevert (RequestType _Type, address[] memory _objs) public {
        Request memory req = Request(_Type, _objs);
        address _id = msg.sender;
        require(isReceivedRequest[hashRequest(req)], "Request has not been received");
        removeReceivedRequest(_id, req);
    }

    function receiveCompletedRequestCancel (RequestType _Type, address[] memory _objs) public {
        Request memory req = Request(_Type, _objs);
        address _id = msg.sender;
        require(isCompletedRequest[hashRequest(req)], "Request is not completed");
        removeCompletedRequest(_id, req);
    }



    function sendRequest (address _id, Request memory req) internal {
        Requestable rInstance = Requestable(_id);
        rInstance.receiveRequest(req.Type, req.objs);
    }

    function sendRequestDecline (address _id, Request memory req) internal {
        Requestable rInstance = Requestable(_id);
        rInstance.receiveRequestDecline(req.Type, req.objs);
    }

    function sendRequestRevert (address _id, Request memory req) internal {
        Requestable rInstance = Requestable(_id);
        rInstance.receiveRequestRevert(req.Type, req.objs);
    }

    function sendCompletedRequestCancel (address _id, Request memory req) internal {
        Requestable rInstance = Requestable(_id);
        rInstance.receiveCompletedRequestCancel(req.Type, req.objs);
    }



    function addSentRequest (address _id, Request memory req) internal {
        addSentRequestHook(_id, req);
        removeRequest(pendingRequests, isPendingRequest, req);
        addRequest(sentRequests, isSentRequest, req);
    }

    function removeSentRequest (address _id, Request memory req) internal {
        removeSentRequestHook(_id, req);
        removePendingObjs(req);
        removeRequest(sentRequests, isSentRequest, req);
    }

    function addReceivedRequest (address _id, Request memory req) internal {
        addReceivedRequestHook(_id, req);
        addRequest(receivedRequests, isReceivedRequest, req);
    }

    function removeReceivedRequest (address _id, Request memory req) internal {
        removeReceivedRequestHook(_id, req);
        removeRequest(receivedRequests, isReceivedRequest, req);
    }

    function addCompletedRequest (address _id, Request memory req) internal {
        addCompletedRequestHook(_id, req);
        addRequest(completedRequests, isCompletedRequest, req);
    }

    function removeCompletedRequest (address _id, Request memory req) internal {
        removeCompletedRequestHook(_id, req);
        removeRequest(completedRequests, isCompletedRequest, req);
    }



    function addSentRequestHook (address _id, Request memory req) internal;
    function removeSentRequestHook (address _id, Request memory req) internal;

    function addReceivedRequestHook (address _id, Request memory req) internal;
    function removeReceivedRequestHook (address _id, Request memory req) internal;

    function addCompletedRequestHook (address _id, Request memory req) internal;
    function removeCompletedRequestHook (address _id, Request memory req) internal;



    function hashRequest (Request memory req) pure internal returns (bytes32) {
        return keccak256(abi.encodePacked(req.Type, req.objs));
    }

    function addRequest (Request[] storage array, mapping (bytes32 => bool) storage map, Request memory req) internal {
        require(!map[hashRequest(req)], "Already exists");
        array.push(req);
        map[hashRequest(req)] = true;
    }

    function removeRequest (Request[] storage array, mapping (bytes32 => bool) storage map, Request memory req) internal {
        require(map[hashRequest(req)], "Not found");
        for (uint i = 0; i < array.length; i++) {
            if (hashRequest(array[i]) == hashRequest(req)) {
              array[i] = array[array.length - 1];
              delete array[array.length - 1];
              array.length--;
              break;
            }
        }
        map[hashRequest(req)] = false;
    }

    function removePendingObjs (Request memory req) internal {
        for (uint i = 0; i < req.objs.length; i++) {
            isPendingObj[req.objs[i]] = false;
        }
    }



// Modifiers



    modifier onlyOwner {
        require(msg.sender == ownerID, "Only owner can call this function");
        _;
    }
}
