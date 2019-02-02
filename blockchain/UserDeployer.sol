pragma solidity ^0.5.1;

import "./src/interfaces/DeployerInterface.sol";
import "./src/User.sol";

contract UserDeployer is DeployerInterface {
    constructor () public {}
    function deploy (address _main, address _ownerID, string memory _name, string memory _physicalAddress, string memory _registrationNumber) public returns (address) {
        User newUser = new User(_main, _ownerID);
        return address(newUser);
    }
}


