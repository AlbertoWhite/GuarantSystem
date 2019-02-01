var express = require('express');
var router = express.Router();
var playersScheme = require('../../../db/DBSchema');
var dbhelper = require('../../../db/DBHelper');

router.get('/In', function (req, res) {
      var pUser = dbhelper.getAllUsers;//TODO tmp

      Promise.all([pUser]).then(function([user]){//TODO tmp
        res.render('players/serviceCenterIn.html',{
            listOfUsers : user,
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

  var pManufacturer = dbhelper.getAllManufacturers;//TODO tmp

  Promise.all([pManufacturer,pServiceCenter]).then(function([manuf,sc]){//TODO tmp
    res.render('players/serviceCenter.html',{
        listOfManufacterer : manuf,
        serviceCenter : sc,
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
  var pManufacturer = dbhelper.getAllManufacturers;//TODO tmp

  Promise.all([pManufacturer]).then(function([manuf]){//TODO tmp
    res.render('players/serviceCenter/partners/addPartners.html',{
        listOfManufacterer : manuf
    });
  }).catch(function(err){
    console.log('Error: '+ err);
  });
});

router.get('/requests/apply/:reqId',function(req,res){
  res.redirect('/players/serviceCenter/requests/list');
});

router.get('/partners/addPartners/apply/:reqId',function(req,res){
  res.redirect('/players/serviceCenter/partners/addPartners');
});

router.post('/In', function (req, res) {
  res.redirect('/players/serviceCenter/In');
});

module.exports = router;