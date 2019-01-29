contract User {
     address id = address(this);
     address owner;
     address[] offers;
     address[] SC;

     mapping (address => address) offerToOwner;
     mapping (address => bool) offersForProduct;
     mapping (address => bool) requestsFromSC;
      
    constructor (){
        owner = msg.sender;
    }
      
     function sell(address _item, address _newOwner){
     require (msg.sender == owner, 'You are not owner');
     User u = User(_newOwner);
     require (offersForProduct[_newOwner] == true, 'There are no offers form this user');
     require (offerToOwner[offers[i]] == _item, 'There are no such products form this user');
      if (offers.length > 1) {
                    offers[i] = offers[offers.length-1];
                    offersForProduct[offers[i]]  = true;
                    offerToOwner[offers[i]] = offerToOwner[offers[offers.length-1]];
                    delete offerToOwner[offers[offers.length-1]];
                    delete offers[offers.length-1];
                }
                delete offerToOwner[offers[i]];
                delete offers[i];
                Item i = Item(_item);
                i.newOwner(_newOwner);
                return;
         
     }


     function Offer (address _newOwner, address _item) { 
       User u = User(_newOwner);
       u.addOffer(_item);
     }

     
     function addOffer( address _item) {
        offers.push(_newOwner);
        offersForProduct[_newOwner]  = true;
        offerToOwner[offers[offers.length-1]] = _item;
      }
    
    function toService(address _SC, address _item) {
        Item I = Item(_item);
        ServiceCenter SC =  ServiceCenter(_SC);
        SC.fromUser(owner, _item, I.manufacturerID);
    } 

    function fromService (address _item){
        require (requestsFromSC[_item] != true, "You already have this require");
        SC.push(_item);
        requestsFromSC[_item];      
    }
    
}