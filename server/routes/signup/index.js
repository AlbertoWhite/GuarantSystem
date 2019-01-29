var express = require('express');
var router = express.Router();

router.get('/', function (req, res) {
  res.render('signup.html');
});

router.post('/', function (req, res) {
  res.redirect('/guarantee/list');
});

module.exports = router;