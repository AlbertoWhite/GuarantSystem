pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

import "./meta/Partnerable.sol";
import "./meta/Transferable.sol";

import "./interfaces/Main.sol";
import "./interfaces/Item.sol";

contract ServiceCenter is Partnerable, Transferable {
    Main public main;

    string public name;
    string public physicalAddress;
    string public registrationNumber;

    address[] manufacturers;
    address[] pendingItems;

    mapping (address => bool) isInManufacturers;
    mapping (address => bool) isPendingItem;



    constructor (address _main, address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        main = Main(_main);
        ownerID = _ownerID;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



// Getters



    function getInfo () view public returns (string memory, string memory, string memory) {
        return (name, physicalAddress, registrationNumber);
    }

    function getManufacturers () view public returns (address[] memory) {
        return manufacturers;
    }

    function getPendingItems () view public returns (address[] memory) {
        return pendingItems;
    }



// Internal



    function addSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.USER, "Wrong contract type");
        }
    }
    function removeSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.USER, "Wrong contract type");
        }
    }

    function addReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.USER, "Wrong contract type");
        }
    }
    function removeReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.USER, "Wrong contract type");
        }
    }

    function addCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");

            addManufacturer(_id);
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.USER, "Wrong contract type");

            for (uint i = 0; i < req.objs.length; i++) {
                if (!isPendingItem[req.objs[i]]) {
                  addPendingItem(req.objs[i]);
                  Item(req.objs[i]).statusOnService();
                } else {
                  removePendingItem(req.objs[i]);
                }
            }
        }
    }
    function removeCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.PARTNERSHIP) {
            Main.ContractType cType = main.contractType(_id);
            require(cType == Main.ContractType.MANUFACTURER, "Wrong contract type");

            removeManufacturer(_id);
        } else if (req.Type == Requestable.RequestType.TRANSFER) {
            revert("Cannot cancel completed transfer");
        }
    }



    function addPendingItem (address iID) internal { addAddress(pendingItems, isPendingItem, iID); }
    function removePendingItem (address iID) internal { removeAddress(pendingItems, isPendingItem, iID); }

    function addManufacturer (address mID) internal { addAddress(manufacturers, isInManufacturers, mID); }
    function removeManufacturer (address mID) internal { removeAddress(manufacturers, isInManufacturers, mID); }



    function addAddress (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(!map[aID], "Already exists");

        array.push(aID);
        map[aID] = true;
    }

    function removeAddress (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(map[aID], "Not found");

        for (uint i = 0; i < array.length; i++) {
            if (array[i] == aID) {
              array[i] = array[array.length - 1];
              delete array[array.length - 1];
              array.length--;
              break;
            }
        }
        map[aID] = false;
    }
}

