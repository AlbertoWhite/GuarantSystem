pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

import "./meta/Requestable.sol";

contract Partnerable is Requestable {
    function makePartnershipRequest () onlyOwner public returns (Request memory) {
        RequestType Type = RequestType.PARTNERSHIP;
        address[] memory objs;
        Request memory req = makeRequest(Type, objs);
        return req;
    }
}

