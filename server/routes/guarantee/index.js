var express = require('express');
var router = express.Router();
var mypass = require('../../MyPassport');

router.use(mypass.mustAuthenticatedMw);

router.get('/list', function (req, res) {
    res.render('guarantee/list.html',{guaranteeList : [{
        id              : 'id',
        ownerID : 'ownerID'    ,   
        serial     : 'serial' ,   
        info         : 'info'  ,
        manufacturerID  : 'manufacturerID' ,
        vendorID : 'vendorID'     ,
        created    : 'created'    ,
        warrantyPeriod : 'warrantyPeriod' ,
        warrantyTerms : 'warrantyTerms', 
        activated   : 'activated'  ,
        status  : 'status'        ,
        history   : 'history'     
    }]});//TODO tmp
});

router.get('/info/:gid', function (req, res) {
    res.render('guarantee/info.html');
});

module.exports = router;