pragma solidity ^0.5.1;

contract Deployer {
    constructor () public {}
    function deploy (address _main, address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address);
}
