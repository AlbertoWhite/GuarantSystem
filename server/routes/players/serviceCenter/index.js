var express = require('express');
var router = express.Router();
var playersScheme = require('../../../db/DBSchema');

router.get('/In', function (req, res) {
  res.render('players/serviceCenterIn.html');
});

router.get('/requests/list', function (req, res) {
  res.render('players/serviceCenter/requests/list.html');
});

router.get('/partners/list', function (req, res) {
  res.render('players/serviceCenter/partners/list.html');
});

router.get('/:id', function (req, res) {
  var pServiceCenter = new Promise(function(resolve, reject) {
    console.log('ID: '+req.params.id);
    var serviceCenter = playersScheme.ServiceCenter.findOne({_id : req.params.id}, function(err, serviceCenter) {
      if(err) return reject(err);
      console.log('Vendor ',err, serviceCenter);
      resolve(serviceCenter);
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

  Promise.all([pManufacturer,pServiceCenter]).then(function([manuf,sc]){//TODO tmp
    res.render('players/serviceCenter.html',{
        listOfManufacterer : manuf,
        serviceCenter : sc
    });
  }).catch(function(err){
    console.log('Error: '+ err);
  });
});

module.exports = router;