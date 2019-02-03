var express = require('express');
var router = express.Router();
var playersScheme = require('../../../db/DBSchema');
var dbhelper = require('../../../db/DBHelper');

router.get('/In', function (req, res) {

  var pVendor = dbhelper.getAllVendors;//TODO tmp

  Promise.all([pVendor]).then(function([vend]){//TODO tmp
    res.render('players/manufacturerIn.html',{
        listOfVendors : vend,
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

router.get('/requests/list', function (req, res) {
  res.render('players/manufacturer/requests/list.html',{//TODO tmp
    listofReceivedPartnerships : ['listofReceivedPartnerships1','listofReceivedPartnerships2'],
    listofRequestedPartnerships : ['listofRequestedPartnerships1','listofRequestedPartnerships2']
  });
});

router.get('/partners/list', function (req, res) {
  var pVendor = dbhelper.getAllVendors;//TODO tmp
  var pServiceCenter = dbhelper.getAllServiceCenter;//TODO tmp

  Promise.all([pVendor,pServiceCenter]).then(function([vend,sc]){//TODO tmp
    res.render('players/manufacturer/partners/list.html',{
        listOfVendors : vend,
        listOfServiceCenters : sc
    });
  }).catch(function(err){
    console.log('Error: '+ err);
  });
});

router.get('/makeGuarantee', function (req, res) {
  res.render('players/manufacturer/makeGuarantee.html');
});

router.get('/:id', function (req, res) {
  var pManufacturer = new Promise(function(resolve, reject) {
    console.log('ID: '+req.params.id);
    var manuf = playersScheme.Manufacturer.findOne({_id : req.params.id}, function(err, manuf) {
      if(err) return reject(err);
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

router.get('/partners/addPartners', function (req, res) {
  var pVendor = dbhelper.getAllVendors;//TODO tmp
  var pServiceCenter = dbhelper.getAllServiceCenter;//TODO tmp

  Promise.all([pVendor,pServiceCenter]).then(function([vend,sc]){//TODO tmp
    res.render('players/manufacturer/partners/addPartners.html',{
        listOfVendors : vend,
        listOfServiceCenters : sc
    });
  }).catch(function(err){
    console.log('Error: '+ err);
  });
});

router.get('/requests/apply/:reqId',function(req,res){
  res.redirect('/players/manufacturer/requests/list');
});

router.get('/partners/addPartners/apply/:reqId',function(req,res){
  res.redirect('/players/manufacturer/partners/addPartners');
});

router.post('/In', function (req, res) {
  res.redirect('/players/manufacturer/In');
});

module.exports = router;