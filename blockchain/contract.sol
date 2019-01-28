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

    constructor (string memory serialArg, string memory infoArg, uint warrantyPeriodArg, string memory warrantyTermsArg) public {
        manufacturerID = msg.sender;
        serial = serialArg;
        info = infoArg;
        warrantyPeriod = warrantyPeriodArg;
        warrantyTerms = warrantyTermsArg;
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

    constructor (string memory nameArg, string memory physicalAddressArg, string memory registrationNumberArg) public {
        ownerID = msg.sender;
        name = nameArg;
        physicalAddress = physicalAddressArg;
        registrationNumber = registrationNumberArg;
    }

    function createItem (string memory serialArg, string memory infoArg, uint warrantyPeriodArg, string memory warrantyTermsArg) public {
        Item newItem = new Item(serialArg, infoArg, warrantyPeriodArg, warrantyTermsArg);
        pendingItems.push(newItem.id());
    }

    function addVendor (address v) public {
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

    function removeVendor (address v) public {
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

    function addServiceCenter (address sc) public {
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

    function removeServiceCenter (address sc) public {
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

    constructor (string memory nameArg, string memory physicalAddressArg, string memory registrationNumberArg) public {
        ownerID = msg.sender;
        name = nameArg;
        physicalAddress = physicalAddressArg;
        registrationNumber = registrationNumberArg;
    }

    function addManufacturer (address m) public {
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

    function removeManufacturer (address m) public {
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

    constructor (string memory nameArg, string memory physicalAddressArg, string memory registrationNumberArg) public {
        ownerID = msg.sender;
        name = nameArg;
        physicalAddress = physicalAddressArg;
        registrationNumber = registrationNumberArg;
    }

    function addManufacturer (address m) public {
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

    function removeManufacturer (address m) public {
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
}
