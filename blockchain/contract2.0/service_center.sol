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