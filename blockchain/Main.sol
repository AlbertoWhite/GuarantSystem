pragma solidity ^0.5.1;

import "./Item.sol"
import "./User.sol"
import "./Manufacturer.sol";
import "./Vendor.sol"
import "./ServiceCenter.sol"



contract Main {
    enum ContractType {ITEM, USER, MANUFACTURER, VENDOR, SERVICE_CENTER};
    mapping (address => ContractType) public getContractType;

    function registerUser () public returns (address) {
        newUser = new User(msg.sender);
        getContractType[address(newUser)] = ContractType.USER;
        return address(newUser);
    }

    function registerManufacturer (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        newManufacturer = new Manufacturer(msg.sender, _name, _physicalAddress, _registrationNumber);
        getContractType[address(newManufacturer)] = ContractType.MANUFACTURER;
        return address(newManufacturer);
    }

    function registerVendor (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        newVendor = new Vendor(msg.sender, _name, _physicalAddress, _registrationNumber);
        getContractType[address(newVendor)] = ContractType.Vendor;
        return address(newVendor);
    }

    function registerServiceCenter (string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        newServiceCenter = new ServiceCenter(msg.sender, _name, _physicalAddress, _registrationNumber);
        getContractType[address(newServiceCenter)] = ContractType.SERVICE_CENTER;
        return address(newServiceCenter);
    }
}
