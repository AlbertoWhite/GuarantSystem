var express = require('express');
var router = express.Router();
var mypass = require('../../MyPassport');

router.use(mypass.mustAuthenticatedMw);

router.get('/list', function (req, res) {
  res.render('requests/list.html',{listOfRequests : [{_id:'1',info: 'requests1'},{_id:'2',info: 'requests2'}]});//TODO tmp
});

router.get('/apply/:reqId',function(req,res){
  res.redirect('/requests/list');
});

module.exports = router;