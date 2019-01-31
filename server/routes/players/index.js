var express = require('express');
var router = express.Router();

const signup = require('./signup');
const signin = require('./signin');
const manufacturer = require('./manufacturer');
const seller = require('./seller');
const service = require('./service');
const vendor = require('./vendor');
const serviceCenter = require('./serviceCenter');


router.get('/', function (req, res) {
    res.render('players/index.html');
});

router.use('/signup', signup);
router.use('/signin', signin);
router.use('/manufacturer', manufacturer);
router.use('/seller', seller);
router.use('/service', service);
router.use('/vendor', vendor);
router.use('/serviceCenter', serviceCenter);


module.exports = router;