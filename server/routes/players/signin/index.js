var express = require('express');
var router = express.Router();
var mypass = require('../../MyPassport');

router.get('/', function (req, res) {
  res.render('/players/signin.html');
});

//router.post('/', mypass.login);

module.exports = router;