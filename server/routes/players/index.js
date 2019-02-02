var express = require('express');
var router = express.Router();
var dbhelper = require('../../db/DBHelper');


const signup = require('./signup');
const signin = require('./signin');
const manufacturer = require('./manufacturer');
const seller = require('./seller');
const service = require('./service');
const vendor = require('./vendor');
const serviceCenter = require('./serviceCenter');


router.get('/', function (req, res) {
    var pManufacturer = dbhelper.getAllManufacturers;
    var pVendor = dbhelper.getAllVendors;
    var pServiceCenter = dbhelper.getAllServiceCenter;

      Promise.all([pManufacturer,pVendor,pServiceCenter]).then(function([manuf,vend,sc]){
        res.render('players/index.html',{
            listOfManufacterer : manuf,
            listOfVendors : vend,
            listOfServiceCenters : sc
        });
      }).catch(function(err){
        console.log('Error: '+ err);
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