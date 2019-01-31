pragma solidity ^0.5.1;

import "./User.sol";
import "./Manufacturer.sol";
import "./Vendor.sol";
import "./ServiceCenter.sol";

contract Main {
    Deployer userDeployer;
    Deployer manufacturerDeployer;
    Deployer vendorDeployer;
    Deployer serviceCenterDeployer;

    enum ContractType {NON_AUTHORIZED, ITEM, USER, MANUFACTURER, VENDOR, SERVICE_CENTER}
    mapping (address => ContractType) contractType;
    function getContractType (address a) view public returns (ContractType) { return contractType[a]; }

    constructor () public {
        userDeployer = new UserDeployer();
        manufacturerDeployer = new ManufacturerDeployer();
        vendorDeployer = new VendorDeployer();
        serviceCenterDeployer = new ServiceCenterDeployer();
    }

    function registerUser (address _ownerID) public returns (address) {
        address newUser = userDeployer.deploy(_ownerID, "", "", "");
        contractType[newUser] = ContractType.USER;
        return newUser;
    }

    function registerManufacturer (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        address newManufacturer = manufacturerDeployer.deploy(_ownerID, _name, _physicalAddress, _registrationNumber);
        contractType[newManufacturer] = ContractType.MANUFACTURER;
        return newManufacturer;
    }

    function registerVendor (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        address newVendor = vendorDeployer.deploy(_ownerID, _name, _physicalAddress, _registrationNumber);
        contractType[newVendor] = ContractType.VENDOR;
        return newVendor;
    }

    function registerServiceCenter (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        address newServiceCenter = serviceCenterDeployer.deploy(_ownerID, _name, _physicalAddress, _registrationNumber);
        contractType[newServiceCenter] = ContractType.SERVICE_CENTER;
        return newServiceCenter;
    }
}

contract Deployer {
    Main public main;

    function deploy (address a, string memory s1, string memory s2, string memory s3) public returns (address) {}
}

contract UserDeployer is Deployer {
    constructor () public {
        main = Main(msg.sender);
    }

    function deploy (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        User newUser = new User(_ownerID);
        return address(newUser);
    }
}

contract ManufacturerDeployer is Deployer {
    constructor () public {
        main = Main(msg.sender);
    }

    function deploy (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        Manufacturer newManufacturer = new Manufacturer(_ownerID, _name, _physicalAddress, _registrationNumber);
        return address(newManufacturer);
    }
}

contract VendorDeployer is Deployer {
    constructor () public {
        main = Main(msg.sender);
    }

    function deploy (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        Vendor newVendor = new Vendor(_ownerID, _name, _physicalAddress, _registrationNumber);
        return address(newVendor);
    }
}

contract ServiceCenterDeployer is Deployer {
    constructor () public {
        main = Main(msg.sender);
    }

    function deploy (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        ServiceCenter newServiceCenter = new ServiceCenter(_ownerID, _name, _physicalAddress, _registrationNumber);
        return address(newServiceCenter);
    }
}
