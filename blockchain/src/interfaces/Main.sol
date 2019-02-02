pragma solidity ^0.5.1;

contract Main {
    enum ContractType {NON_AUTHORIZED, ITEM, USER, MANUFACTURER, VENDOR, SERVICE_CENTER}
    mapping (address => ContractType) public contractType;

    function registerItem (address iID) public;
}

