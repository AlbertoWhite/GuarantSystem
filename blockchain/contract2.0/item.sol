pragma solidity ^0.5.1;

contract Item {
    address public id = address(this);
    string serial;
    string info;
    address manufacturerID;
    address vendorID;
    address ownerID;
    uint created;
    uint warrantyPeriod;
    string warrantyTerms;
    uint activated;
    struct[] history{ 
    string[] actions = {
            'creation', 
            'transfer', 
            'changed owner',
            'service',
            'return',
    }
    string info;
    }
    // Status status;
    // Action[] history;

    constructor (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) public {
        manufacturerID = msg.sender;
        serial = _serial;
        info = _info;
        warrantyPeriod = _warrantyPeriod;
        warrantyTerms = _warrantyTerms;
    }
}

