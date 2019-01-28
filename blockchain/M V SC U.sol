pragma solidity ^0.5.1;

contract Manufacturer {
    address public id = address(this);
    string public name;
    string public physicalAddress;
    string public registrationNumber;
    address[] sellers;
    address[] serviceCenters;

    address[] pendingSellers;
    address[] pendingServiceCenters;

    constructor (string memory nameArg, string memory physicalAddressArg, string memory registrationNumberArg) public {
        name = nameArg;
        physicalAddress = physicalAddressArg;
        registrationNumber = registrationNumberArg;
    }

    function addSeller (address seller) public {
        for (uint i = 0; i < pendingSellers.length; i++) {
            if (seller == pendingSellers[i]) {
                sellers.push(seller);
                delete pendingSellers[i];
                return;
            }
        }
        Seller sellerInstance = Seller(seller);
        sellerInstance.receiveManufacturer(id);
    }

    function removeSeller (address seller) public {
        for (uint i = 0; i < sellers.length; i++) {
            if (seller == sellers[i]) {
                delete sellers[i];
                break;
            }
        }
        Seller sellerInstance = Seller(seller);
        sellerInstance.removeManufacturer(id);
    }
}

contract Seller {
    address public id = address(this);
    address[] manufacturers;

    address[] pendingManufacturers;

    function receiveManufacturer (address manufacturer) public {
        for (uint i = 0; i < pendingManufacturers.length; i++) {
            if (manufacturer == pendingManufacturers[i]) {
                return;
            }
        }
        pendingManufacturers.push(manufacturer);
    }

    function removeManufacturer (address manufacturer) public {
        for (uint i = 0; i < manufacturers.length; i++) {
            if (manufacturer == manufacturers[i]) {
                delete manufacturers[i];
                break;
            }
        }
        Manufacturer manufacturerInstance = Manufacturer(manufacturer);
        manufacturerInstance.removeSeller(id);
    }
}
