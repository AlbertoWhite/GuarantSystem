var express = require('express');
var router = express.Router();
var playersScheme = require('../../../db/DBSchema')

router.get('/In', function (req, res) {
  res.render('players/vendorIn.html');
});

router.get('/requests/list', function (req, res) {
  res.render('players/vendor/requests/list.html');
});

router.get('/partners/list', function (req, res) {
  res.render('players/vendor/partners/list.html');
});

router.get('/:id', function (req, res) {
  var pVendor = new Promise(function(resolve, reject) {
    console.log('ID: '+req.params.id);
    var vendor = playersScheme.Vendor.findOne({_id : req.params.id}, function(err, vendor) {
      if(err) return reject(err);
      console.log('Vendor ',err, vendor);
      resolve(vendor);
    });
  });

  //TODO товары

  var pManufacturer = new Promise(function(resolve, reject) {//TODO tmp
    var manuf = playersScheme.Manufacturer.find({}, function(err, manuf) {
      if(err) return reject(err);
      console.log('Manufacturer',err, manuf, manuf.length);
      resolve(manuf);
    });
  });

  Promise.all([pManufacturer,pVendor]).then(function([manuf,vend]){//TODO tmp
    res.render('players/vendor.html',{
        listOfManufacterer : manuf,
        vendor : vend,
    });
  }).catch(function(err){
    console.log('Error: '+ err);
  });
});

module.exports = router;