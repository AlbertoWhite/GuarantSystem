pragma solidity ^0.5.1;

import "./src/interfaces/Deployer.sol";
import "./src/Vendor.sol";

contract VendorDeployer is Deployer {
   constructor () public {}

   function deploy (address _main, address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        Vendor newVendor = new Vendor(_main, _ownerID, _name, _physicalAddress, _registrationNumber);
        return address(newVendor);
    }
}


