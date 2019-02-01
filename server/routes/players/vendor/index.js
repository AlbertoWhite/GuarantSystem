var express = require('express');
var router = express.Router();

router.get('/In', function (req, res) {
  res.render('players/vendorIn.html');
});

router.get('/:id', function (req, res) {
  res.render('players/vendor.html');
});

router.get('/requests/list', function (req, res) {
  res.render('players/manufacturer/requests/list.html');
});

router.get('/partners/list', function (req, res) {
  res.render('players/manufacturer/partners/list.html');
});

module.exports = router;