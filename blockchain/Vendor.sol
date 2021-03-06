pragma solidity ^0.5.1;

import "./Main.sol";
import "./Organization.sol";
import "./Item.sol";

contract Vendor is Organization {
    Main public main;

    address[] public manufacturers;
    address[] public pendingItems;

    mapping (address => bool) isInManufacturers;
    mapping (address => bool) isPendingItem;



    constructor (address _main, address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        main = Main(_main);
        ownerID = _ownerID;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Public



    function setOwnerToItem (address uID, address iID) onlyOwner public {
        Main.ContractType cType = main.getContractType(uID);
        require((cType == Main.ContractType.USER), "Wrong contract type");

        Item iInstance = Item(iID);
        iInstance.setOwner(uID);
    }

    function activateWarranty (address iID) onlyOwner public {
        Item iInstance = Item(iID);
        iInstance.activateWarranty();
    }



// Internal



    function _addPartnerMethod (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        _addManufacturer(pID);
    }

    function _removePartnerMethod (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        _removeManufacturer(pID);
    }

    function _sendPartnershipRequest (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipRequest();
    }

    function _sendPartnershipDecline (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipDecline();
    }

    function _sendPartnershipRevert (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipRevert();
    }

    function _sendPartnershipCancel (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.cancelPartnership(id);
    }

    function _addPendingItem (address iID) internal { _addTo(pendingItems, isPendingItem, iID); }
    function _removePendingItem (address iID) internal { _removeFrom(pendingItems, isPendingItem, iID); }

    function _addManufacturer (address mID) internal { _addTo(manufacturers, isInManufacturers, mID); }
    function _removeManufacturer (address mID) internal { _removeFrom(manufacturers, isInManufacturers, mID); }
}
