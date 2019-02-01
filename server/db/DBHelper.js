var playersScheme = require('../db/DBSchema');
var User = require('../db/UserSchema');

module.exports = {
    getAllManufacturers :  new Promise(function(resolve, reject) {
        var manuf = playersScheme.Manufacturer.find({}, function(err, manuf) {
          if(err) return reject(err);
          console.log('Manufacturer',err, manuf, manuf.length);
          resolve(manuf);
        });
      }),
      getAllVendors : new Promise(function(resolve, reject) {
        var vend = playersScheme.Vendor.find({}, function(err, vend) { 
          if(err) return reject(err);
          console.log('Vendor',err, vend, vend.length);
          resolve(vend);
        });
      }),
      getAllServiceCenter : new Promise(function(resolve, reject) {
        var sc = playersScheme.ServiceCenter.find({}, function(err, sc) { 
          if(err) return reject(err);
          console.log('ServiceCenter',err, sc, sc.length);
          resolve(sc);
        });
      }),
      getAllUsers : new Promise(function(resolve, reject) {
        var user = User.find({}, function(err, user) { 
          if(err) return reject(err);
          console.log('ServiceCenter',err, user);
          resolve(user);
        });
      })
    
}