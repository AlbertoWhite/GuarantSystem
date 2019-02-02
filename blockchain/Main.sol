pragma solidity ^0.5.1;

import "./Deployer.sol";

contract Main {
    address public main = address(this);

    Deployer userDeployer;
    Deployer manufacturerDeployer;
    Deployer vendorDeployer;
    Deployer serviceCenterDeployer;

    enum ContractType {NON_AUTHORIZED, ITEM, USER, MANUFACTURER, VENDOR, SERVICE_CENTER}
    mapping (address => ContractType) contractType;
    function getContractType (address a) view public returns (ContractType) { return contractType[a]; }

    constructor (address _userDeployer, address _manufacturerDeployer, address _vendorDeployer, address _serviceCenterDeployer) public {
        userDeployer = Deployer(_userDeployer);
        manufacturerDeployer = Deployer(_manufacturerDeployer);
        vendorDeployer = Deployer(_vendorDeployer);
        serviceCenterDeployer = Deployer(_serviceCenterDeployer);
    }

    function registerUser (address _ownerID) public returns (address) {
        address newUser = userDeployer.deploy(main, _ownerID, "", "", "");
        contractType[newUser] = ContractType.USER;
        return newUser;
    }

    function registerManufacturer (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        address newManufacturer = manufacturerDeployer.deploy(main, _ownerID, _name, _physicalAddress, _registrationNumber);
        contractType[newManufacturer] = ContractType.MANUFACTURER;
        return newManufacturer;
    }

    function registerVendor (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        address newVendor = vendorDeployer.deploy(main, _ownerID, _name, _physicalAddress, _registrationNumber);
        contractType[newVendor] = ContractType.VENDOR;
        return newVendor;
    }

    function registerServiceCenter (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        address newServiceCenter = serviceCenterDeployer.deploy(main, _ownerID, _name, _physicalAddress, _registrationNumber);
        contractType[newServiceCenter] = ContractType.SERVICE_CENTER;
        return newServiceCenter;
    }
}
