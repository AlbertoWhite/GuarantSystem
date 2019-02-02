pragma solidity ^0.5.1;

import "./src/interfaces/Deployer.sol";

contract Main {
    address public main = address(this);

    address[2][] public userList;
    address[2][] public manufacturerList;
    address[2][] public vendorList;
    address[2][] public serviceCenterList;

    mapping (address => address) public ownerToID;

    Deployer userDeployer;
    Deployer manufacturerDeployer;
    Deployer vendorDeployer;
    Deployer serviceCenterDeployer;

    enum ContractType {NON_AUTHORIZED, ITEM, USER, MANUFACTURER, VENDOR, SERVICE_CENTER}
    mapping (address => ContractType) public contractType;

    constructor (address _userDeployer, address _manufacturerDeployer, address _vendorDeployer, address _serviceCenterDeployer) public {
        userDeployer = Deployer(_userDeployer);
        manufacturerDeployer = Deployer(_manufacturerDeployer);
        vendorDeployer = Deployer(_vendorDeployer);
        serviceCenterDeployer = Deployer(_serviceCenterDeployer);
    }

    function registerUser (address _ownerID) public {
        address newUser = userDeployer.deploy(main, _ownerID, "", "", "");
        contractType[newUser] = ContractType.USER;
        userList.push([_ownerID, newUser]);
        ownerToID[_ownerID] = newUser;
    }

    function registerManufacturer (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        address newManufacturer = manufacturerDeployer.deploy(main, _ownerID, _name, _physicalAddress, _registrationNumber);
        contractType[newManufacturer] = ContractType.MANUFACTURER;
        manufacturerList.push([_ownerID, newManufacturer]);
        ownerToID[_ownerID] = newManufacturer;
    }

    function registerVendor (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        address newVendor = vendorDeployer.deploy(main, _ownerID, _name, _physicalAddress, _registrationNumber);
        contractType[newVendor] = ContractType.VENDOR;
        vendorList.push([_ownerID, newVendor]);
        ownerToID[_ownerID] = newVendor;
    }

    function registerServiceCenter (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {
        address newServiceCenter = serviceCenterDeployer.deploy(main, _ownerID, _name, _physicalAddress, _registrationNumber);
        contractType[newServiceCenter] = ContractType.SERVICE_CENTER;
        serviceCenterList.push([_ownerID, newServiceCenter]);
        ownerToID[_ownerID] = newServiceCenter;
    }
}
