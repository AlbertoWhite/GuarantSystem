pragma solidity ^0.5.1;
 
contract Item {
       address id = address(this);
       string physicalAddress;
       string info;
       address manfactureID;
       address sellerID;
       address ownerID;
       address probablyNewOwnerID;
       struct createdDate {
           uint16 year;
           uint8 month;
           uint8 day;
        }
        uint 16 guareanteePeriod;
        string warrantyTerms;
        struct activatedDate {
           uint16 year;
           uint8 month;
           uint8 day;
           uint8 hour;
           uint8 minute;
        }
        string status;
        // тип под вопросом   history []; 
      
       constructor() internal {
       ownerID = msg.sender;
     }