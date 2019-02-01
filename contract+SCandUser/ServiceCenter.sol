pragma solidity ^0.5.1;

import "./Main.sol";
import "./Organization.sol";
import "./Item.sol";
import "./User.sol";

contract ServiceCenter is Organization {
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

    address[] inProcessing;
    address[] pendingItem;
    mapping (address => address) itemsOwner;
    mapping (address => bool) broken;
    mapping (address => bool) isInProcessing;
   
// Public
 
//  
   function newItem (address _us, address _item, address man) public onlyOwner {
       require(broken[_item]==false || isInProcessing[_item]==false, "The application is already being processed");
       if (isInManufacturers[man] == true){
       _addTo (pendingItem, broken, _item);
       itemsOwner[_item] = _us;
       }
       else {
        refuseRequest(_us, _item);
       }
   }
   
   function recieveRequest (address _us, address _item) internal {
       require(broken[_item] == true);
      _removeFromAddressArray(pendingItem, _item);
      broken[_item] = false;
      inProcessing.push(_item);
      isInProcessing[_item] = true;
   } 
   
   function refuseRequest (address _us, address _item) internal {
       require(broken[_item] == true);
      _removeFrom(pendingItem, broken, _item);
      delete itemsOwner[_item];
       User u = User(_us);
       u.refuseFromSC(_item);
   }
   
   function repaired (address _us, address _item) internal {
        _removeFromAddressArray(inProcessing, _item);
        User u = User(_us);
        u.getItem(_item);
   }
// 

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
    
    //
    function _addTo (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(!map[aID], "Already exists");

        array.push(aID);
        map[aID] = true;
    }//

    function _addPendingItem (address iID) internal { _addTo(pendingItems, isPendingItem, iID); }
    function _removePendingItem (address iID) internal { _removeFrom(pendingItems, isPendingItem, iID); }

    function _addManufacturer (address mID) internal { _addTo(manufacturers, isInManufacturers, mID); }
    function _removeManufacturer (address mID) internal { _removeFrom(manufacturers, isInManufacturers, mID); }
}

