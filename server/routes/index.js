var express = require('express');
var router = express.Router();

const signup = require('./signup');
const signin = require('./signin');
const signout = require('./signout');
const guarantee = require('./guarantee');
const players = require('./players');


router.get('/', function (req, res) {
  
  var data = {
    name : 'Slava'
  }

  return res.render('index.html',data);
});

router.use('/signup', signup);
router.use('/signin', signin);
router.use('/signout', signout);
router.use('/guarantee', guarantee);
router.use('/players',players);

module.exports = router;