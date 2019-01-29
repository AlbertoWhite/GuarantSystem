var express = require('express');
var router = express.Router();

const signup = require('./signup');
const signin = require('./signin');
const guarantee = require('./guarantee');


router.get('/', function (req, res) {
  res.render('index.html');
});

router.use('/signup', signup);
router.use('/signin', signin);
router.use('/guarantee', guarantee);

module.exports = router;