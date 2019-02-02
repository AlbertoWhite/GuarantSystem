pragma solidity ^0.5.1;

import "./Main.sol";
import "./Item.sol";

contract User {
    Main public main;

    address public id = address(this);
    address private ownerID;

    constructor (address _main, address _ownerID) public {
        main = Main(_main);
        ownerID = _ownerID;
    }



// Public



    function changeOwner (address uID, address iID) onlyOwner public {
        Main.ContractType cType = main.getContractType(uID);
        require((cType == Main.ContractType.USER), "Wrong contract type");

        Item iInstance = Item(iID);
        iInstance.changeOwner(uID);
    }



// Modifiers



    modifier onlyOwner {
        require((msg.sender == ownerID), "Permission denied");
        _;
    }
}
