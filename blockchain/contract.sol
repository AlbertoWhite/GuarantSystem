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

    constructor (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        ownerID = msg.sender;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }

    function createItem (string memory _serial, string memory _info, uint _warrantyPeriod, string memory _warrantyTerms) onlyOwner public {
        Item newItem = new Item(_serial, _info, _warrantyPeriod, _warrantyTerms);
        pendingItems.push(newItem.id());
    }

    function addVendor (address v) onlyOwner public {
        for (uint i = 0; i < pendingVendors.length; i++) {
            if (v == pendingVendors[i]) {
                vendors.push(v);
                delete pendingVendors[i];
                return;
            }
        }
        Vendor vInstance = Vendor(v);
        vInstance.receiveManufacturer(id);
    }

    function receiveVendor (address v) public {
        for (uint i = 0; i < pendingVendors.length; i++) {
            if (v == pendingVendors[i]) {
                return;
            }
        }
        pendingVendors.push(v);
    }

    function removeVendor (address v) onlyOwnerOrVendor public {
        bool exists = false;
        for (uint i = 0; i < vendors.length; i++) {
            if (v == vendors[i]) {
                delete vendors[i];
                exists = true;
                break;
            }
        }
        if (exists == true) {
            Vendor vInstance = Vendor(v);
            vInstance.removeManufacturer(id);
        }
    }

    function addServiceCenter (address sc) onlyOwner public {
        for (uint i = 0; i < pendingServiceCenters.length; i++) {
            if (sc == pendingServiceCenters[i]) {
                serviceCenters.push(sc);
                delete pendingServiceCenters[i];
                return;
            }
        }
        ServiceCenter scInstance = ServiceCenter(sc);
        scInstance.receiveManufacturer(id);
    }

    function receiveServiceCenter (address sc) public {
        for (uint i = 0; i < pendingServiceCenters.length; i++) {
            if (sc == pendingServiceCenters[i]) {
                return;
            }
        }
        pendingServiceCenters.push(sc);
    }

    function removeServiceCenter (address sc) onlyOwnerOrServiceCenter public {
        bool exists = false;
        for (uint i = 0; i < serviceCenters.length; i++) {
            if (sc == serviceCenters[i]) {
                delete serviceCenters[i];
                exists = true;
                break;
            }
        }
        if (exists == true) {
            ServiceCenter scInstance = ServiceCenter(sc);
            scInstance.removeManufacturer(id);
        }
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

    constructor (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        ownerID = msg.sender;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }

    function addManufacturer (address m) onlyOwner public {
        for (uint i = 0; i < pendingManufacturers.length; i++) {
            if (m == pendingManufacturers[i]) {
                manufacturers.push(m);
                delete pendingManufacturers[i];
                return;
            }
        }
        Manufacturer mInstance = Manufacturer(m);
        mInstance.receiveVendor(id);
    }

    function receiveManufacturer (address m) public {
        for (uint i = 0; i < pendingManufacturers.length; i++) {
            if (m == pendingManufacturers[i]) {
                return;
            }
        }
        pendingManufacturers.push(m);
    }

    function removeManufacturer (address m) onlyOwnerOrManufacturer public {
        bool exists = false;
        for (uint i = 0; i < manufacturers.length; i++) {
            if (m == manufacturers[i]) {
                delete manufacturers[i];
                exists = true;
                break;
            }
        }
        if (exists == true) {
            Manufacturer mInstance = Manufacturer(m);
            mInstance.removeVendor(id);
        }
    }
}



contract ServiceCenter {
    address id = address(this);
    address ownerID;
    string name;
    string physicalAddress;
    string registrationNumber;
    address[] manufacturers;
    address[] pendingManufacturers;
    address[] requests;
    mapping(address => address) product;

    constructor (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        ownerID = msg.sender;
        name = _name;
        physicalAddress = _physicalAddress;
        registrationNumber = _registrationNumber;
    }

    function addManufacturer (address m) onlyOwner public {
        for (uint i = 0; i < pendingManufacturers.length; i++) {
            if (m == pendingManufacturers[i]) {
                manufacturers.push(m);
                delete pendingManufacturers[i];
                return;
            }
        }
        Manufacturer mInstance = Manufacturer(m);
        mInstance.receiveServiceCenter(id);
    }

    function receiveManufacturer (address m) public {
        for (uint i = 0; i < pendingManufacturers.length; i++) {
            if (m == pendingManufacturers[i]) {
                return;
            }
        }
        pendingManufacturers.push(m);
    }

    function removeManufacturer (address m) onlyOwnerOrManufacturer public {
        bool exists = false;
        for (uint i = 0; i < manufacturers.length; i++) {
            if (m == manufacturers[i]) {
                delete manufacturers[i];
                exists = true;
                break;
            }
        }
        if (exists == true) {
            Manufacturer mInstance = Manufacturer(m);
            mInstance.removeServiceCenter(id);
        }
    }


    function putRequest(address _owner, address _item) {
        for(uint i = 0; i < reqests.length; i++){
         if( requests[i] = _owner)
         return;
    }
        reqests.push(_owner);
        product[requests[requests.length-1]=_item;
    }

    function checkRequests() returns(bool){
        for(uint i = 0; i < requests.length; i++){
            for(uint j = 0; j < manufacturers.length; j++){
            if(request[i].manufacturerID == manufactures[j])
            return true;
            }
        }
        return false;
    }

}

contract User {
     address id = address(this);
     address owner;
     address[] offers;
     mapping (address => address) offerToOwner;

    constructor (){
        owner = msg.sender;
    }

     function buy(address _item, address owner) {
     Item i = Item(_item);
     i.newOwner(owner);
     }


     function present(address _item, address _newOwner) {
     require (msg.sender == owner);
     Item i = Item(_item);
     i.newOwner(_newOwner);
     }

     function sell(address _item, address _newOwner){
     require (msg.sender == owner);
     User u = User(_newOwner);
     for(uint i = 0; i < offers.lenght; i++){
            if(offers[i] == _newOwner && offerToOwner[offers[i]] == _item){
            delete offerToOwner[offers[i]];
            delete offers[i];
            Item i = Item(_item);
            i.newOwner(_newOwner);
            return;
            }
        }
     }


     function Offer (address _newOwner, address _item) {
       User u = User(_newOwner);
       u.addOffer(_item);
     }


     function addOffer( address _item) {
        offers.push(_newOwner);
        offerToOwner[offers[offers.length-1]] = _item;
      }

    function addRequest(address _SC, address _item) {
        ServiceCenter SC =  ServiceCenter(_SC);
        SC.putRequest(owner, _item);
    }
}
