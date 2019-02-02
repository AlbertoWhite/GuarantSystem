pragma solidity ^0.5.1;

contract MainInterface {
    // constructor (address _userDeployer, address _manufacturerDeployer, address _vendorDeployer, address _serviceCenterDeployer) public {}
    enum ContractType {NON_AUTHORIZED, ITEM, USER, MANUFACTURER, VENDOR, SERVICE_CENTER}
    mapping (address => ContractType) public contractType;

    // function registerUser (address _ownerID) public {}

    // function registerManufacturer (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {}

    // function registerVendor (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {}

    // function registerServiceCenter (address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public {}
}

