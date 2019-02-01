var express = require('express');
var router = express.Router();
var playersScheme = require('../../db/DBSchema');


const signup = require('./signup');
const signin = require('./signin');
const manufacturer = require('./manufacturer');
const seller = require('./seller');
const service = require('./service');
const vendor = require('./vendor');
const serviceCenter = require('./serviceCenter');


router.get('/', function (req, res) {
    var pManufacturer = new Promise(function(resolve, reject) {
        var manuf = playersScheme.Manufacturer.find({}, function(err, manuf) {
          console.log('Manufacturer',err, manuf, manuf.length);
          resolve(manuf);
        });
      });
    
      var pVendor = new Promise(function(resolve, reject) {
        var vend = playersScheme.Vendor.find({}, function(err, vend) { 
          console.log('Vendor',err, vend, vend.length);
          resolve(vend);
        });
      });
    
      var pServiceCenter = new Promise(function(resolve, reject) {
        var sc = playersScheme.ServiceCenter.find({}, function(err, sc) { 
          console.log('ServiceCenter',err, sc, sc.length);
          resolve(sc);
        });
      });

      Promise.all([pManufacturer,pVendor,pServiceCenter]).then(function([manuf,vend,sc]){
        res.render('players/index.html',{
            listOfManufacterer : manuf,
            listOfVendors : vend,
            listOfServiceCenters : sc
        });
      });
    
});

router.use('/signup', signup);
router.use('/signin', signin);
router.use('/manufacturer', manufacturer);
router.use('/seller', seller);
router.use('/service', service);
router.use('/vendor', vendor);
router.use('/serviceCenter', serviceCenter);


module.exports = router;