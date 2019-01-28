pragma solidity ^0.5.1;

contract Item {
    address id = address(this);
    string serial;
    string info;
    address manufacturerID;
    address vendorID;
    address ownerID;
    Time created;
    Time warrantyPeriod;
    string warrantyTerms;
    Time activated;

    // Status status;
    // Action[] history;

    constructor() public {
        manufacturerID = msg.sender;
    }

    struct Time {
        uint16 year;
        uint8 month;
        uint8 day;
    }
}
