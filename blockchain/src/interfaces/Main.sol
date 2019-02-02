pragma solidity ^0.5.1;

contract Main {
    constructor (address _userDeployer, address _manufacturerDeployer, address _vendorDeployer, address _serviceCenterDeployer) public {}
    enum ContractType {NON_AUTHORIZED, ITEM, USER, MANUFACTURER, VENDOR, SERVICE_CENTER}
    mapping (address => ContractType) public contractType;
}

