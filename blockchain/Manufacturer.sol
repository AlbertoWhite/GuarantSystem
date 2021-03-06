pragma solidity ^0.5.1;

import "./Main.sol";
import "./Organization.sol";
import "./Item.sol";

contract Manufacturer is Organization {
    Main public main;

    address[] public vendors;
    address[] public serviceCenters;
    address[] public pendingItems;

    mapping (address => bool) isInVendors;
    mapping (address => bool) isInServiceCenters;
    mapping (address => bool) isPendingItem;



    constructor (address _main, address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        main = Main(_main);
        ownerID = _ownerID;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Public



    function createItem (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) onlyOwner public returns (address) {
        Item newItem = new Item(address(main), _serial, _info, _warrantyPeriod, _warrantyTerms);
        _addPendingItem(address(newItem));
        return (address(newItem));
    }

    function setVendorToItem (address vID, address iID) onlyOwner public {
        Main.ContractType cType = main.getContractType(vID);
        require((cType == Main.ContractType.VENDOR), "Wrong contract type");

        Item iInstance = Item(iID);
        iInstance.setVendor(vID);
    }

    function activateWarranty (address iID) onlyOwner public {
        Item iInstance = Item(iID);
        iInstance.activateWarranty();
    }



// Internal



    function _addPartnerMethod (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

        if (cType == Main.ContractType.VENDOR) { _addVendor(pID); }
        else if (cType == Main.ContractType.SERVICE_CENTER) { _addServiceCenter(pID); }
    }

    function _removePartnerMethod (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

        if (cType == Main.ContractType.VENDOR) { _removeVendor(pID); }
        else if (cType == Main.ContractType.SERVICE_CENTER) { _removeServiceCenter(pID); }
    }

    function _sendPartnershipRequest (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipRequest();
    }

    function _sendPartnershipDecline (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipDecline();
    }

    function _sendPartnershipRevert (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.receivePartnershipRevert();
    }

    function _sendPartnershipCancel (address pID) internal {
        Main.ContractType cType = main.getContractType(pID);
        require(((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.SERVICE_CENTER)), "Wrong contract type");

        Organization oInstance = Organization(pID);
        oInstance.cancelPartnership(id);
    }

    function _addPendingItem (address iID) internal { _addTo(pendingItems, isPendingItem, iID); }
    function _removePendingItem (address iID) internal { _removeFrom(pendingItems, isPendingItem, iID); }

    function _addVendor (address vID) internal { _addTo(vendors, isInVendors, vID); }
    function _removeVendor (address vID) internal { _removeFrom(vendors, isInVendors, vID); }

    function _addServiceCenter (address scID) internal { _addTo(serviceCenters, isInServiceCenters, scID); }
    function _removeServiceCenter (address scID) internal { _removeFrom(serviceCenters, isInServiceCenters, scID); }
}
