pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

import "./meta/Requestable.sol";

contract Transferable is Requestable {
    function makeTransferRequest (address[] memory _objs) onlyOwner public returns (Request memory) {
        RequestType Type = RequestType.TRANSFER;
        address[] memory objs = _objs;
        Request memory req = makeRequest(Type, objs);
        return req;
    }
}
