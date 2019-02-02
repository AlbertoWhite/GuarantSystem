pragma solidity ^0.5.1;

contract Item {
    function activateWarranty () public;
    function setOwner (address uID) public;
    function changeOwner (address uID) public;
    function statusNormal () onlyServiceCenter public;
    function statusOnService () onlyServiceCenter public;
    function statusDefected () onlyServiceCenter public;
    function statusReturned () onlyManufacturerOrVendor public;
}
