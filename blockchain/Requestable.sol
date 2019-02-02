pragma solidity ^0.5.1;

contract Request {
    address sender;
    address receiver;

    enum RequestType {NULL, PARTNERSHIP}
    RequestType Type;
    address[] objs;

    constructor (address _receiver, RequestType _Type, address[] memory _objs) public {
        sender = msg.sender;
        receiver = _receiver;
        Type = _Type;
        objs = _objs;
    }
}

contract Requestable {
    address public id = address(this);
    address internal ownerID;

    address[] public receivedRequests;
    address[] public sentRequests;
    address[] public completedRequests;

    mapping (address => bool) isReceivedRequest;
    mapping (address => bool) isSentRequest;
    mapping (address => bool) isCompletedRequest;
    mapping (address => bool) isPendingObj;



// Public



    function createRequest (Request.RequestType _Type, address[] memory _objs) public returns (address) {
        Request newRequest = new Request(_Type, _objs);
        return address(newRequest);
    }

    function request (address _id, address req) onlyOwner public {
        require(!isSentRequest[req], "Request has already been sent");
        _addSentRequest(_id, req);
        _sendRequest(_id, req);
    }

    function acceptRequest (address _id, address req) onlyOwner public {
        require(isReceivedRequest[req], "No such request");
        _addCompletedRequest(_id, req);
        _removeReceivedRequest(_id, req);
        _sendRequest(_id, req);
    }

    function declineRequest (address _id, address req) onlyOwner public {
        require(isReceivedRequest[req], "No such request");
        _removeReceivedRequest(_id, req);
        _sendRequestDecline(_id, req);
    }

    function revertRequest (address _id, address req) onlyOwner public {
        require(isSentRequest[req], "No such request");
        _removeSentRequest(_id, req);
        _sendRequestRevert(_id, req);
    }

    function cancelCompletedRequest (address _id, address req) public {
        require(((msg.sender == ownerID) || ((msg.sender == _id) && isCompletedRequest[req])), "Not enough permissions");
        _removeCompletedRequest(_id, req);
        _sendCompletedRequestCancel(_id, req);
    }

    function receiveRequest (address req) public {
        address _id = msg.sender;
        require(!isReceivedRequest[req], "Request has already been received");

        if (isSentRequest[req]) {
            _addCompletedRequest(_id, req);
            _removeSentRequest(_id, req);
        } else {
            _addReceivedRequest(_id, req);
        }
    }

    function receiveRequestDecline (address req) public {
        address _id = msg.sender;
        require(isSentRequest[req], "Request has not been sent");
        _removeSentRequest(_id, req);
    }

    function receiveRequestRevert (address req) public {
        address _id = msg.sender;
        require(isReceivedRequest[req], "Request has not been received");
        _removeReceivedRequest(_id, req);
    }

    function receiveCompletedRequestCancel (address req) public {
        address _id = msg.sender;
        require(isCompletedRequest[req], "Request is not completed");
        _removeCompletedRequest(_id, req);
    }



// Internal



    function _sendRequest (address _id, address req) internal {
        Requestable rInstance = Requestable(_id);
        rInstance.receiveRequest(req);
    }

    function _sendRequestDecline (address _id, address req) internal {
        Requestable rInstance = Requestable(_id);
        rInstance.receiveRequestDecline(req);
    }

    function _sendRequestRevert (address _id, address req) internal {
        Requestable rInstance = Requestable(_id);
        rInstance.receiveRequestRevert(req);
    }

    function _sendCompletedRequestCancel (address _id, address req) internal {
        Requestable rInstance = Requestable(_id);
        rInstance.receiveCompletedRequestCancel(req);
    }



    function _addSentRequest (address _id, address req) internal {
        _addSentRequestMethod(_id, req);
        isSentRequest[req] = true;
    }

    function _removeSentRequest (address _id, address req) internal {
        _removeSentRequestMethod(_id, req);
        isSentRequest[req] = false;
    }

    function _addReceivedRequest (address _id, address req) internal {
        _addReceivedRequestMethod(_id, req);
        isReceivedRequest[req] = true;
    }

    function _removeReceivedRequest (address _id, address req) internal {
        _removeReceivedRequestMethod(_id, req);
        isReceivedRequest[req] = false;
    }

    function _addCompletedRequest (address _id, address req) internal {
        _addCompletedRequestMethod(_id, req);
        isCompletedRequest[req] = true;
    }

    function _removeCompletedRequest (address _id, address req) internal {
        _removeCompletedRequestMethod(_id, req);
        isCompletedRequest[req] = false;
    }



    function _addSentRequestMethod (address _id, address req) internal {}
    function _removeSentRequestMethod (address _id, address req) internal {}

    function _addReceivedRequestMethod (address _id, address req) internal {}
    function _removeReceivedRequestMethod (address _id, address req) internal {}

    function _addCompletedRequestMethod (address _id, address req) internal {}
    function _removeCompletedRequestMethod (address _id, address req) internal {}



// Modifiers



    modifier onlyOwner {
        require(msg.sender == ownerID, "Only owner can call this function");
        _;
    }
}
