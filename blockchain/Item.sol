pragma solidity ^0.5.1;

contract Item {
    address id = address(this);
    string serial;
    string info;
    address manfacturerID;
    address vendorID;
    address ownerID;
    Time created;
    Time warrantyPeriod;
    string warrantyTerms;
    Time activated;

    // Status status;
    // Action[] history;

    constructor() internal {
        ownerID = msg.sender;
    }

    struct Time {
        uint16 year;
        uint8 month;
        uint8 day;
    }
}
