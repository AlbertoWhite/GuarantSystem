var express = require('express');
var router = express.Router();
var playersScheme = require('../../../db/DBSchema');
var mainCtrl = require('../../../../web3/MainCtrl');

router.get('/', function (req, res) {
  res.render('players/signup.html');
});

router.post('/', function (req, res, next){
    if(req.body.type!="Manufacturer" &&
    req.body.type!="Vendor" &&
    req.body.type!="ServiceCenter") return next(new Error('Incorrect type'));

    var publicKey = req.body.publicKey;
    var name = req.body.name;
    var physicalAddress = req.body.physicalAddress;
    var registrationNumber = req.body.registrationNumber;

    var playerPromise = mainCtrl.register[req.body.type](publicKey,name,physicalAddress,registrationNumber);

    Promise.all([playerPromise]).then(function([txAdress]){
      var player = new playersScheme[req.body.type]({
        publicKey: publicKey,
        secretKey: "secret",
        txAddress: txAdress,
        name: name,
        physicalAddress: physicalAddress,
        registrationNumber: registrationNumber});
    
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
  });

module.exports = router;