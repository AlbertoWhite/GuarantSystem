var express = require('express');
var router = express.Router();
var mypass = require('../../MyPassport');

router.get('/', mypass.logout);

module.exports = router;