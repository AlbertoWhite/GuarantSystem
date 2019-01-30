pragma solidity ^0.5.1;

import "./Main.sol";
import "./Organization.sol";



contract ServiceCenter is Organization {
    Main main;

    address private ownerID;

    address[] public manufacturers;
    address[] public pendingItems;

    mapping (address => bool) isInManufacturers;
    mapping (address => bool) isPendingItem;



    constructor (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        main = Main(msg.sender);
        ownerID = _ownerID;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Public



// Internal



    function _addPartner (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        _addManufacturer(pID);
    }

    function _removePartner (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        _removeManufacturer(pID);
    }

    function _requestPartnership (address pID) internal {
        Main.ContractType pType = main.getContractType(pID);
        require(pType == Main.ContractType.MANUFACTURER, "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipRequest();
    }

    function _requestCancelPartnership (address pID) internal {
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

