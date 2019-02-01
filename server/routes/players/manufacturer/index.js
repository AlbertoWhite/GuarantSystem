var express = require('express');
var router = express.Router();

router.get('/In', function (req, res) {
  res.render('players/manufacturerIn.html');
});

router.get('/requests/list', function (req, res) {
  res.render('players/manufacturer/requests/list.html');
});

router.get('/partners/list', function (req, res) {
  res.render('players/manufacturer/partners/list.html');
});

router.get('/makeGuarantee', function (req, res) {
  res.render('players/manufacturer/makeGuarantee.html');
});

router.get('/:id', function (req, res) {
  res.render('players/manufacturer.html');
});

router.post('/:man_id/create', function (req, res) {
  res.redirect('/players/manufacturer/:man_id');
});

module.exports = router;