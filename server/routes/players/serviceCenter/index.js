var express = require('express');
var router = express.Router();

router.get('/In', function (req, res) {
  res.render('players/serviceCenterIn.html');
});

router.get('/:id', function (req, res) {
  res.render('/players/serviceCenter.html');
});

module.exports = router;