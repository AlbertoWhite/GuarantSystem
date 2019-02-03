pragma solidity ^0.5.1;

contract Item {
    function activateWarranty () public;
    function setOwner (address uID) public;
    function changeOwner (address uID) public;
    function statusNormal () public;
    function statusOnService () public;
    function statusDefected () public;
    function statusReturned () public;
    enum Status {NORMAL, ON_SERVICE, DEFECTED, RETURNED}
    enum Action {CREATION, TRANSFER, CHANGED_OWNER, SERVICE, RETURN}
}
