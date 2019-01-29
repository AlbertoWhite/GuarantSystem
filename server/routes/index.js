var express = require('express');
var router = express.Router();

const signup = require('./signup');
const signin = require('./signin');
const guarantee = require('./guarantee');


router.get('/', function (req, res) {
  
  var data = {
    name : 'Slava'
  }

  return res.render('index.html',data);
});

router.use('/signup', signup);
router.use('/signin', signin);
router.use('/guarantee', guarantee);

module.exports = router;