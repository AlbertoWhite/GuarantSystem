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
  var pserviceCenter = new Promise(function(resolve, reject) {
    console.log('ID: '+req.params.id);
    var serviceCenter = playersScheme.ServiceCenter.findOne({_id : req.params.id}, function(err, serviceCenter) {
      if(err) return reject(err);
      console.log('Vendor ',err, serviceCenter);
      resolve(serviceCenter);
    });
  });

  pserviceCenter.then(function(sc){
    res.render('players/serviceCenter.html',{serviceCenter : sc});
  }).catch(function(err){
    console.log('Error: '+ err);
  });
});

module.exports = router;