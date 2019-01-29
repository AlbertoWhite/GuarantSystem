var express = require('express');
var router = express.Router();

const manufacturer = require('./manufacturer');
const seller = require('./seller');
const service = require('./service');


router.get('/', function (req, res) {
    res.render('players/index.html');
});

router.use('/manufacturer', manufacturer);
router.use('/seller', seller);
router.use('/service', service);


module.exports = router;