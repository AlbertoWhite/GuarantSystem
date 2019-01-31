pragma solidity ^0.5.1;

import "./Main.sol";
import "./Manufacturer.sol";

contract Item {
    Main public main;

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

    Status public status;
    Action[] public history;

    constructor (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) public {
        main = Manufacturer(msg.sender).main();

        Main.ContractType pType = main.getContractType(msg.sender);
        require((pType == Main.ContractType.MANUFACTURER), "Wrong contract type");

        manufacturerID = msg.sender;
        serial = _serial;
        info = _info;
        warrantyPeriod = _warrantyPeriod;
        warrantyTerms = _warrantyTerms;
    }



// Public



    function setVendor (address vID) onlyManufacturer public {
        require((vendorID == address(0)), "Vendor is already set");
        Main.ContractType pType = main.getContractType(vID);
        require((pType == Main.ContractType.VENDOR), "Wrong contract type");
        vendorID = vID;
    }

    function setOwner (address uID) onlyVendor public {
        require((ownerID == address(0)), "Owner is already set");
        Main.ContractType pType = main.getContractType(uID);
        require((pType == Main.ContractType.USER), "Wrong contract type");
        ownerID = uID;
    }

    function changeOwner (address uID) onlyOwner public {
        Main.ContractType pType = main.getContractType(uID);
        require((pType == Main.ContractType.USER), "Wrong contract type");
        ownerID = uID;
    }



// Internal



    enum Status {NORMAL, ON_SERVICE, DEFECTED, RETURNED}

    enum Action {CREATION, TRANSFER, CHANGED_OWNER, SERVICE, RETURN}



// Modifiers



    modifier onlyOwner {
        require((msg.sender == ownerID), "Permission denied");
        _;
    }

    modifier onlyManufacturer {
        require((msg.sender == manufacturerID), "Permission denied");
        _;
    }

    modifier onlyVendor {
        require((msg.sender == vendorID), "Permission denied");
        _;
    }
}
