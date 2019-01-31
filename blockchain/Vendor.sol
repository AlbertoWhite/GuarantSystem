pragma solidity ^0.5.1;

import "./Organization.sol";

contract Vendor is Organization {
    address[] public manufacturers;
    address[] public pendingItems;

    mapping (address => bool) isInManufacturers;
    mapping (address => bool) isPendingItem;



    constructor (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        main = Deployer(msg.sender).main();
        ownerID = _ownerID;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Public



// Internal



    function _addPartnerMethod (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        _addManufacturer(pID);
    }

    function _removePartnerMethod (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        _removeManufacturer(pID);
    }

    function _sendPartnershipRequest (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipRequest();
    }

    function _sendPartnershipDecline (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipDecline();
    }

    function _sendPartnershipRevert (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipRevert();
    }

    function _sendPartnershipCancel (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.cancelPartnership(id);
    }

    function _addPendingItem (address iID) internal { _addTo(pendingItems, isPendingItem, iID); }
    function _removePendingItem (address iID) internal { _removeFrom(pendingItems, isPendingItem, iID); }

    function _addManufacturer (address mID) internal { _addTo(manufacturers, isInManufacturers, mID); }
    function _removeManufacturer (address mID) internal { _removeFrom(manufacturers, isInManufacturers, mID); }
}
