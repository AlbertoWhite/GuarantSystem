var express = require('express');
var router = express.Router();
var playersScheme = require('../../../db/DBSchema');

router.get('/', function (req, res) {
  res.render('players/signup.html');
});

router.post('/', function (req, res, next){
    if(req.body.type!="Manufacterer" &&
    req.body.type!="Vendor" &&
    req.body.type!="ServiceCenter") return next(new Error('Incorrect type'));
  
    var player = new playersScheme[req.body.type]({
    publickKey: req.body.publickKey,
    secretKey: "secret",
    txAddress: "txAdd",
    name: req.body.name,
    realAddress: req.body.physicalAddress,
    regNumber: req.body.registrationNumber});

    if(player.name!=""){
      playersScheme[req.body.type].findOne({name : player.name},function(err,player_l){
          return err
          ? next(err)
          : player_l
            ? next(new Error(req.body.type + ' already exists.'))
            : player.save(function(err,player){
              if (err) return next(err);
            });
      });
    }
  });

module.exports = router;