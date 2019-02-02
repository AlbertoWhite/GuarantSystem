pragma solidity ^0.5.1;

import "./Deployer.sol";
import "./Manufacturer.sol";

contract ManufacturerDeployer is Deployer {
    function deploy (address _main, address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        Manufacturer newManufacturer = new Manufacturer(_main, _ownerID, _name, _physicalAddress, _registrationNumber);
        return address(newManufacturer);
    }
}
