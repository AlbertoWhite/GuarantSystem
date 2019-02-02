var express = require('express');
var router = express.Router();

router.get('/', function (req, res) {
  res.render('/players/signin.html');
});

//router.post('/', mypass.login);

module.exports = router;