
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
    mapping (address => address) itemToVendor;



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

    function _addPendingItemM (address iID, address _vend) internal {
        require(isPendingItem[iID] == false, "Item is already on the pending list");

        pendingItems.push(iID);
        itemToVendor[iID] = _vend;
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
        newItem.history[newItem.history].actions[0];
        newItem.history[newItem.history].info = null;
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
     
    function fromVendor(address _vendor, address _item){
        require (ItemToVendor[_item] == false, 'you have this item in your pending list');
        pendingItems.push(_item);
        ItemToVendor[_item] = true;
    }
     
     function toVendor(address _vend, address _item){
        vendor V = vendor(_vend);
        V._addPendingItem (_item, id);
    }
}

