pragma solidity ^0.5.1;

contract Item {
    address public id = address(this);
    address private ownerID;
    string public serial;
    string public info;
    address public manufacturerID;
    address public vendorID;
    uint public created;
    uint public warrantyPeriod;
    string public warrantyTerms;
    uint public activated;

    // Status public status;
    // Action[] public history;

    constructor (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) public {
        manufacturerID = msg.sender;
        ownerID = manufacturerID;
        serial = _serial;
        info = _info;
        warrantyPeriod = _warrantyPeriod;
        warrantyTerms = _warrantyTerms;
    }



// Public




// Modifiers



    modifier onlyOwner {
        require(msg.sender == ownerID, "Only owner can call this function");
        _;
    }

    modifier onlyManufacturer {
        require(msg.sender == ownerID, "Only manufacturer can call this function");
        _;
    }

    modifier onlyVendor {
        require(msg.sender == ownerID, "Only vendor can call this function");
        _;
    }
}
