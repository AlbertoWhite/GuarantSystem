var playersScheme = require('../db/DBSchema');
var User = require('../db/UserSchema');

module.exports = {
  getAllManufacturers: function () {
    return new Promise(function (resolve, reject) {
      var manuf = playersScheme.Manufacturer.find({}, function (err, manuf) {
        if (err) return reject(err);
        resolve(manuf);
      });
    })
  },
  getAllVendors: function () {
    return new Promise(function (resolve, reject) {
      var vend = playersScheme.Vendor.find({}, function (err, vend) {
        if (err) return reject(err);
        resolve(vend);
      });
    })
  },
  getAllServiceCenter: function () {
    return new Promise(function (resolve, reject) {
      var sc = playersScheme.ServiceCenter.find({}, function (err, sc) {
        if (err) return reject(err);
        resolve(sc);
      });
    })
  },
  getAllUsers: function () {
    return new Promise(function (resolve, reject) {
      var user = User.find({}, function (err, user) {
        if (err) return reject(err);
        resolve(user);
      });
    })
  }

}