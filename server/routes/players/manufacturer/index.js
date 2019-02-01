var express = require('express');
var router = express.Router();
var playersScheme = require('../../../db/DBSchema');
var dbhelper = require('../../../db/DBHelper');

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

  var pVendor = dbhelper.getAllVendors;//TODO tmp

  var pServiceCenter = dbhelper.getAllServiceCenter;//TODO tmp

  Promise.all([pManufacturer,pVendor,pServiceCenter]).then(function([manuf,vend,sc]){//TODO tmp
    res.render('players/manufacturer.html',{
        manufacturer : manuf,
        listOfVendors : vend,
        listOfServiceCenters : sc,
        listOfpendingItems : [{
          serial : 'serial',
          info : 'info',
          warrantyPeriod : 'warrantyPeriod',
          warrantyTerms : 'warrantyTerms'
        }]
    });
  }).catch(function(err){
    console.log('Error: '+ err);
  });
  
});

router.post('/:man_id/create', function (req, res) {
  res.redirect('/players/manufacturer/:man_id');
});

module.exports = router;