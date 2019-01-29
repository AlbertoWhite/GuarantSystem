var express = require('express');
var router = express.Router();
var mypass = require('../../MyPassport');

router.get('/', function (req, res) {
  res.render('signup.html');
});

router.post('/', mypass.register);

module.exports = router;