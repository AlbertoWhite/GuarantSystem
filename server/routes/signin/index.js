var express = require('express');
var router = express.Router();

router.get('/', function (req, res) {
  res.render('signin.html');
});

router.get('/', function (req, res) {
  res.redirect('/guarantee/list');
});

module.exports = router;