pragma solidity ^0.5.1;

contract ItemInterface {
    function activateWarranty () public;
    function setOwner (address uID) public;
    function changeOwner (address uID) public;
}
