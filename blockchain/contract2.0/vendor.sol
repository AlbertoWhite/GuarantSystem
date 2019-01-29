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
    mapping (address => address) itemToManufacturer;



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

    function _addPendingItem (address iID, address _man) internal {
   //     require(isPendingItem[iID] == false &&, "Item is already on the pending list");
        require(isPendingItem[iID] == false, "Item is already on the pending list");

        pendingItems.push(iID);
        isPendingItem[iID] = true;
        itemToManufacture[iID] = _man;  
    
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
    
    function fromManifacture(){
        
    }
     
     function toManifacture(address _manuf, address _item){
        Manufacture M = Manufacture(_manuf);
        M._addPendingItemM(_item, id);
    }
}

