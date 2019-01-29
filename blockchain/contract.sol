pragma solidity ^0.5.1;



contract Item {
    address public id = address(this);
    string serial;
    string info;
    address manufacturerID;
    address vendorID;
    address ownerID;
    uint created;
    uint warrantyPeriod;
    string warrantyTerms;
    uint activated;

    // Status status;
    // Action[] history;

    constructor (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) public {
        manufacturerID = msg.sender;
        serial = _serial;
        info = _info;
        warrantyPeriod = _warrantyPeriod;
        warrantyTerms = _warrantyTerms;
    }
}



contract Manufacturer {
    address id = address(this);
    address ownerID;
    string name;
    string physicalAddress;
    string registrationNumber;

    address[] vendors;
    address[] serviceCenters;
    address[] pendingVendors;
    address[] pendingServiceCenters;
    address[] pendingItems;



    mapping (address => bool) isVendor;
    mapping (address => bool) isServiceCenter;
    mapping (address => bool) isPendingVendor;
    mapping (address => bool) isPendingServiceCenter;
    mapping (address => bool) isPendingItem;



    constructor (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        ownerID = msg.sender;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



    modifier onlyOwner {
        require(msg.sender == ownerID, "Only owner can call this function");
        _;
    }

    modifier onlyOwnerOrVendor {
        require(((msg.sender == ownerID) || (isVendor[msg.sender] == true)), "Only owner or partner vendor can call this function");
        _;
    }

    modifier onlyOwnerOrServiceCenter {
        require(((msg.sender == ownerID) || (isServiceCenter[msg.sender] == true)), "Only owner or partner service center can call this function");
        _;
    }



    function _removeFromAddressArray (address[] array, address value) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
              array[i] = array[array.length - 1];
              delete array[array.length - 1];
              array.length = array.length - 1;
            }
        }
    }

    function _addPendingItem (address iID) internal {
        require(isPendingItem[iID] == false, "Item is already on the pending list");

        pendingItems.push(iID);
        isPendingItem[iID] = true;
    }

    function _addVendor (address vID) internal {
        require(isVendor[vID] == false, "Vendor is already partnered with");

        vendors.push(vID);
        isVendor[vID] = true;
    }

    function _addServiceCenter (address scID) internal {
        require(isServiceCenter[scID] == false, "Service Center is arleady partnered with");

        serviceCenters.push(scID);
        isServiceCenter[scID] = true;
    }

    function receiveVendor () public {
        address vID = msg.sender;
        require(isPendingVendor[vID] == false, "Partnership request has already been sent");

        pendingVendors.push(vID);
        isPendingVendor[vID] = true;
    }

    function receiveServiceCenter () public {
        address scID = msg.sender;
        require(isPendingServiceCenter[scID] == false, "Partnership request has already been sent");

        pendingServiceCenters.push(scID);
        isPendingServiceCenter[scID] = true;
    }



    function createItem (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) onlyOwner public {
        Item newItem = new Item(_serial, _info, _warrantyPeriod, _warrantyTerms);
        _addPendingItem(address(newItem));
    }



    function addVendor (address vID) onlyOwner public {
        if (isPendingVendor[vID] == true) {
            _addVendor(vID);
            _removeFromAddressArray(pendingVendors, vID);
            isPendingVendor[vID] = false;
        } else {
            Vendor vInstance = Vendor(vID);
            vInstance.receiveManufacturer();
        }
    }

    function removeVendor (address vID) onlyOwnerOrVendor public {
        require(isVendor[vID] == true, "No such vendor");

        _removeFromAddressArray(vendors, vID);
        isVendor[vID] = false;

        Vendor vInstance = Vendor(vID);
        vInstance.removeManufacturer(id);
    }



    function addServiceCenter (address scID) onlyOwner public {
        if (isPendingServiceCenter[scID] == true) {
            _addServiceCenter(scID);
            _removeFromAddressArray(pendingServiceCenters, scID);
            isPendingServiceCenter[scID] = false;
        } else {
            ServiceCenter scInstance = ServiceCenter(scID);
            scInstance.receiveManufacturer();
        }
    }

    function removeServiceCenter (address scID) onlyOwnerOrServiceCenter public {
        require(isServiceCenter[scID] == true, "No such service center");

        _removeFromAddressArray(serviceCenters, scID);
        isServiceCenter[scID] = false;

        ServiceCenter scInstance = ServiceCenter(scID);
        scInstance.removeManufacturer(id);
    }
}



contract Vendor {
    address id = address(this);
    address ownerID;
    string name;
    string physicalAddress;
    string registrationNumber;

    address[] manufacturers;
    address[] pendingManufacturers;
    address[] pendingItems;



    mapping (address => bool) isManufacturer;
    mapping (address => bool) isPendingManufacturer;
    mapping (address => bool) isPendingItem;



    constructor (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        ownerID = msg.sender;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



    modifier onlyOwner {
        require(msg.sender == ownerID, "Only owner can call this function");
        _;
    }

    modifier onlyOwnerOrManufacturer {
        require(((msg.sender == ownerID) || (isManufacturer[msg.sender] == true)), "Only owner or partner manufacturer can call this function");
        _;
    }



    function _removeFromAddressArray (address[] array, address value) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
              array[i] = array[array.length - 1];
              delete array[array.length - 1];
              array.length = array.length - 1;
            }
        }
    }

    function _addPendingItem (address iID) internal {
        require(isPendingItem[iID] == false, "Item is already on the pending list");

        pendingItems.push(iID);
        isPendingItem[iID] = true;
    }

    function _addManufacturer (address mID) internal {
        require(isManufacturer[mID] == false, "Manufacturer is arleady partnered with");

        manufacturers.push(mID);
        isManufacturer[mID] = true;
    }

    function receiveManufacturer () public {
        address mID = msg.sender;
        require(isPendingManufacturer[mID] == false, "Partnership request has already been sent");

        pendingManufacturers.push(mID);
        isPendingManufacturer[mID] = true;
    }



    function addManufacturer (address mID) onlyOwner public {
        if (isPendingManufacturer[mID] == true) {
            _addManufacturer(mID);
            _removeFromAddressArray(pendingManufacturers, mID);
            isPendingManufacturer[mID] = false;
        } else {
            Manufacturer mInstance = Manufacturer(mID);
            mInstance.receiveVendor();
        }
    }

    function removeManufacturer (address mID) onlyOwnerOrManufacturer public {
        require(isManufacturer[mID] == true, "No such manufacturer");

        _removeFromAddressArray(manufacturers, mID);
        isManufacturer[mID] = false;

        Manufacturer mInstance = Manufacturer(mID);
        mInstance.removeVendor(id);
    }
}



contract ServiceCenter {
    address id = address(this);
    address ownerID;
    string name;
    string physicalAddress;
    string registrationNumber;
    
    struct products {
        address id; 
        address items[]; 
    }

    address[] manufacturers;
    address[] pendingManufacturers;
    address[] requests;



    mapping (address => bool) isManufacturer;
    mapping (address => bool) isPendingManufacturer;
    mapping (address => bool) isPendingUser;
    mapping (address => adress)  manufactureOfProduct;
    mapping(address => struct) product;
    mapping (address => bool) items;



    constructor (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        ownerID = msg.sender;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }



    modifier onlyOwner {
        require(msg.sender == ownerID, "Only owner can call this function");
        _;
    }

    modifier onlyOwnerOrManufacturer {
        require(((msg.sender == ownerID) || (isManufacturer[msg.sender] == true)), "Only owner or partner manufacturer can call this function");
        _;
    }



    function _removeFromAddressArray (address[] array, address value) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
              array[i] = array[array.length - 1];
              delete array[array.length - 1];
              array.length = array.length - 1;
            }
        }
    }

    function _addManufacturer (address mID) internal {
        require(isManufacturer[mID] == false, "Manufacturer is arleady partnered with");

        manufacturers.push(mID);
        isManufacturer[mID] = true;
    }

    function receiveManufacturer () public {
        address mID = msg.sender;
        require(isPendingManufacturer[mID] == false, "Partnership request has already been sent");

        pendingManufacturers.push(mID);
        isPendingManufacturer[mID] = true;
    }



    function addManufacturer (address mID) onlyOwner public {
        if (isPendingManufacturer[mID] == true) {
            _addManufacturer(mID);
            _removeFromAddressArray(pendingManufacturers, mID);
            isPendingManufacturer[mID] = false;
        } else {
            Manufacturer mInstance = Manufacturer(mID);
            mInstance.receiveServiceCenter();
        }
    }

    function removeManufacturer (address mID) onlyOwnerOrManufacturer public {
        require(isManufacturer[mID] == true, "No such manufacturer");

        _removeFromAddressArray(manufacturers, mID);
        isManufacturer[mID] = false;

        Manufacturer mInstance = Manufacturer(mID);
        mInstance.removeServiceCenter(id);
    }
   
    function fromUser(address _owner, address _item, address _manuf) {
        require (isPendingUser[_owner] != true || items[_item] != true , "Your request is being processed");
        require (isManufacturers[_manuf] == true, 'We do not cooperate');
        if (isPendingUser[_owner] == true){
        product[_owner].item.push(_item);
        }
        else{
        products p;
        p.id = _owner;
        p.item.push(_item);
        product[_owner] = p;
        }
    
     function toUser (address _owner; address _item){
     User u = User(_owner);
     u.fromService(address _item);
      }     

}

contract User {
     address id = address(this);
     address owner;
     address[] offers;
     address[] SC;

     mapping (address => address) offerToOwner;
     mapping (address => bool) offersForProduct;
     mapping (address => bool) requestsFromSC;
      
    constructor (){
        owner = msg.sender;
    }
      
     function sell(address _item, address _newOwner){
     require (msg.sender == owner, 'You are not owner');
     User u = User(_newOwner);
     require (offersForProduct[_newOwner] == true, 'There are no offers form this user');
     require (offerToOwner[offers[i]] == _item, 'There are no such products form this user');
      if (offers.length > 1) {
                    offers[i] = offers[offers.length-1];
                    offersForProduct[offers[i]]  = true;
                    offerToOwner[offers[i]] = offerToOwner[offers[offers.length-1]];
                    delete offerToOwner[offers[offers.length-1]];
                    delete offers[offers.length-1];
                }
                delete offerToOwner[offers[i]];
                delete offers[i];
                Item i = Item(_item);
                i.newOwner(_newOwner);
                return;
         
     }


     function Offer (address _newOwner, address _item) { 
       User u = User(_newOwner);
       u.addOffer(_item);
     }

     
     function addOffer( address _item) {
        offers.push(_newOwner);
        offersForProduct[_newOwner]  = true;
        offerToOwner[offers[offers.length-1]] = _item;
      }
    
    function toService(address _SC, address _item) {
        Item I = Item(_item);
        ServiceCenter SC =  ServiceCenter(_SC);
        SC.fromUser(owner, _item, I.manufacturerID);
    } 

    function fromService (address _item){
        require (requestsFromSC[_item] != true, "You already have this require");
        SC.push(_item);
        requestsFromSC[_item];      
}
    
}



