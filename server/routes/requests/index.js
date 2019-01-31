var express = require('express');
var router = express.Router();
var mypass = require('../../MyPassport');

router.use(mypass.mustAuthenticatedMw);

router.get('/list', function (req, res) {
  res.render('requests/list.html');
});

router.post('apply/:reqId',function(req,res){
  res.redirect('/requests/list');
});

module.exports = router;