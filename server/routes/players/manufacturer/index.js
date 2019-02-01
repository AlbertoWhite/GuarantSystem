var express = require('express');
var router = express.Router();
var playersScheme = require('../../../db/DBSchema')

router.get('/In', function (req, res) {
  res.render('players/manufacturerIn.html');
});

router.get('/requests/list', function (req, res) {
  res.render('players/manufacturer/requests/list.html');
});

router.get('/partners/list', function (req, res) {
  res.render('players/manufacturer/partners/list.html');
});

router.get('/makeGuarantee', function (req, res) {
  res.render('players/manufacturer/makeGuarantee.html');
});

router.get('/:id', function (req, res) {
  var pManufacturer = new Promise(function(resolve, reject) {
    console.log('ID: '+req.params.id);
    var manuf = playersScheme.Manufacturer.findOne({_id : req.params.id}, function(err, manuf) {
      if(err) return reject(err);
      console.log('Manufacturer',err, manuf);
      resolve(manuf);
    });
  });

  //TODO товары

  var pVendor = new Promise(function(resolve, reject) {//TODO tmp
    var vend = playersScheme.Vendor.find({}, function(err, vend) { 
      if(err) return reject(err);
      console.log('Vendor',err, vend, vend.length);
      resolve(vend);
    });
  });

  var pServiceCenter = new Promise(function(resolve, reject) {//TODO tmp
    var sc = playersScheme.ServiceCenter.find({}, function(err, sc) { 
      if(err) return reject(err);
      console.log('ServiceCenter',err, sc, sc.length);
      resolve(sc);
    });
  });

  Promise.all([pManufacturer,pVendor,pServiceCenter]).then(function([manuf,vend,sc]){//TODO tmp
    res.render('players/manufacturer.html',{
        manufacturer : manuf,
        listOfVendors : vend,
        listOfServiceCenters : sc
    });
  }).catch(function(err){
    console.log('Error: '+ err);
  });
  
});

router.post('/:man_id/create', function (req, res) {
  res.redirect('/players/manufacturer/:man_id');
});

module.exports = router;