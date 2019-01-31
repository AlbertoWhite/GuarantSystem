var express = require('express');
var router = express.Router();

router.get('/In', function (req, res) {
  res.render('players/manufacturerIn.html');
});

router.get('/:id', function (req, res) {
  res.render('players/manufacturer.html');
});

router.post('/:man_id/create', function (req, res) {
  res.redirect('/players/manufacturer/:man_id');
});

module.exports = router;