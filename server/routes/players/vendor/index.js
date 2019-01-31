var express = require('express');
var router = express.Router();

router.get('/In', function (req, res) {
  res.render('players/vendorIn.html');
});

router.get('/:id', function (req, res) {
  res.render('players/vendor.html');
});

module.exports = router;