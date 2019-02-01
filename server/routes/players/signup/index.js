var express = require('express');
var router = express.Router();
var playersScheme = require('../../../db/DBSchema');

router.get('/', function (req, res) {
  res.render('players/signup.html');
});

router.post('/', function (req, res, next){
  console.log(req.body.type);
    if(req.body.type!="Manufacturer" &&
    req.body.type!="Vendor" &&
    req.body.type!="ServiceCenter") return next(new Error('Incorrect type'));
  
    var player = new playersScheme[req.body.type]({
    publicKey: req.body.publicKey,
    secretKey: "secret",
    txAddress: "txAdd",
    name: req.body.name,
    physicalAddress: req.body.physicalAddress,
    registrationNumber: req.body.registrationNumber});

    console.log(player);

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

    res.redirect('/players');
  });

module.exports = router;