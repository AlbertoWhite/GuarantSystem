pragma solidity ^0.5.1;

import "./Main.sol";
import "./Item.sol";
import "./ServiceCenter.sol";

contract User {
    Main public main;
    address public id = address(this);
    
    address private ownerID;
 
    address[] myItems;
    address[] wantToBuy;
    address[] wantToSell;
    mapping (address => bool) forSale;
    mapping (address => bool) forBuying;
    mapping (address => address) oldHolder;
    mapping (address => address) newHolder;
    mapping (address => bool) myItem;
    
    constructor (address _ownerID) public {
        main = Deployer(msg.sender).main();
        ownerID = _ownerID;
    }
    
    address[] brokenAndRefused;
    address[] inSC;
    address[] brokenItem;
    mapping (address => address) itemInService;
    mapping (address => bool) isBroken;
    mapping (address => bool) isBrokenAndRefused;
 //public
 
 // to service center
    function RequestTo (address pID, address _item, address man)  public onlyOwner {
        require(whole(pID, brokenItem, isBroken, _item, itemInService) == true, "Error");
        ServiceCenter SC = ServiceCenter(pID);
        SC.newItem(msg.sender, _item, man);
    }
    
    function _recieveFromSC (address _item) public onlyOwner { inSC.push(_item);} 
    
    function refuseFromSC (address _item) public {
        _removeFrom(brokenItem, isBroken, _item);
        delete itemInService[_item];
        brokenAndRefused.push(_item);
        isBrokenAndRefused[_item] = true;
    }
    
    function getItem (address _item) public {_removeFrom(brokenItem, isBroken, _item);}

//to user
    function _wantToBuy (address pID, address _item) public onlyOwner {  
        Main.ContractType pType = main.getContractType(pID);
        require (pType == Main.ContractType.USER, "Error");
        whole(pID, wantToBuy, forBuying, _item, oldHolder);
        require (forBuying[_item] == false, "error"); 
    } 

    function _agreedForSell (address pID, address _item) public onlyOwner {
        _removeFrom(wantToSell, forSale, _item);
        _removeFrom(myItems, myItem, _item);
        Item i = Item(_item);
        changeOwner(pID, _item);
    }
    
    function refuseBuying (address pID, address _item) internal {
        _removeFrom(wantToSell, forSale, _item);
        User u = User(pID);
        u._RecieveRefuse(msg.sender, _item);
    }
    
    function _RecieveRefuse (address pID, address _item) public onlyOwner {
        _removeFrom(wantToSell, forSale, _item);
    }
    
    function changeOwner (address uID, address iID) public onlyOwner {
        Main.ContractType cType = main.getContractType(uID);
        require((cType == Main.ContractType.USER), "Wrong contract type");

        Item iInstance = Item(iID);
        iInstance.changeOwner(uID);
    }


// internal
    
    function _recieveBuying (address pID, address _item) internal {
        require (forBuying[_item] == true, "you don`t have such request");
        _addTo (myItems, myItem, _item);
        _removeFrom(wantToBuy, forBuying, _item);
        User u = User(pID);
        u._agreedForSell(msg.sender, _item);
    }

    function _wantToSell (address pID, address _item) internal {
        Main.ContractType pType = main.getContractType(pID);
        require (pType == Main.ContractType.USER, "Error");
        whole(pID, wantToSell, forSale, _item, newHolder);
        require (forSale[_item] == false, "Error");
        User u = User(pID);
        u._wantToBuy(msg.sender, _item);
    } 


    function _addTo (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(!map[aID], "Already exists");
        array.push(aID);
        map[aID] = true;
    }

    function whole (address pID,address[] storage array, mapping (address => bool) storage map, address aID, mapping (address => address) storage map2) internal returns(bool) {
       
        _addTo(array, map, aID);
        map2[aID] = pID;
      
    } 
 
    function _removeFrom (address[] storage array, mapping (address => bool) storage map, address aID) internal {
        require(map[aID], "Not found");

        _removeFromAddressArray(array, aID);
        map[aID] = false;
    }
    
    function _removeFromAddressArray (address[] storage array, address value) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
            array[i] = array[array.length - 1];
            delete array[array.length - 1];
            array.length--;
            }
        }
    }


// Modifiers

    modifier onlyOwner {
        require((msg.sender == ownerID), "Permission denied");
        _;
    }
}

