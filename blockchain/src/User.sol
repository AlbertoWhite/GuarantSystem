pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

import "./meta/Transferable.sol";

import "./interfaces/Main.sol";
import "./interfaces/Item.sol";

contract User is Transferable {
    Main public main;

    address public id = address(this);
    address private ownerID;

    address[] items;
    mapping (address => bool) isInItems;

    constructor (address _main, address _ownerID) public {
        main = Main(_main);
        ownerID = _ownerID;
    }



// Public



    function getItems () view public returns (address[] memory) {
        return items;
    }



// Internal



    function addSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.USER), "Wrong contract type");
        }
    }
    function removeSentRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.USER), "Wrong contract type");
        }
    }

    function addReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.USER), "Wrong contract type");
        }
    }
    function removeReceivedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.USER), "Wrong contract type");
        }
    }

    function addCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.TRANSFER) {
            Main.ContractType cType = main.contractType(_id);
            require((cType == Main.ContractType.VENDOR) || (cType == Main.ContractType.USER), "Wrong contract type");

            if (cType == Main.ContractType.VENDOR) {
                for (uint i = 0; i < req.objs.length; i++) {
                    addItem(req.objs[i]);
                }
            } else if (cType == Main.ContractType.USER) {
                for (uint i = 0; i < req.objs.length; i++) {
                    if (isInItems[req.objs[i]]) {
                        removeItem(req.objs[i]);
                        changeOwner(_id, req.objs[i]);
                    } else {
                        addItem(req.objs[i]);
                    }
                }
            }
        }
    }
    function removeCompletedRequestHook (address _id, Requestable.Request memory req) internal {
        if (req.Type == Requestable.RequestType.TRANSFER) {
            revert("Cannot cancel completed transfer");
        }
    }



    function addItem (address iID) internal { addAddress(items, isInItems, iID); }
    function removeItem (address iID) internal { removeAddress(items, isInItems, iID); }

    function changeOwner (address uID, address iID) onlyOwner internal {
        Main.ContractType cType = main.contractType(uID);
        require((cType == Main.ContractType.USER), "Wrong contract type");

        Item iInstance = Item(iID);
        iInstance.changeOwner(uID);
        removeItem(iID);
    }

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
