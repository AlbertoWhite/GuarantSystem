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
  },
  getAllItems : [{
    serial : '1654961341981',
    info : 'Холодильник',
    warrantyPeriod : '4 года',
    warrantyTerms : 'Использование по назначению'
  },{
    serial : '654984616848',
    info : 'Телевизор',
    warrantyPeriod : '3 года',
    warrantyTerms : 'Использование по назначению'
  },{
    serial : '846168464365',
    info : 'Телефон',
    warrantyPeriod : '4 года',
    warrantyTerms : 'Использование по назначению'
  },{
    serial : '7468196816',
    info : 'Чайник',
    warrantyPeriod : '2 года',
    warrantyTerms : 'Использование по назначению'
  },{
    serial : '16541687461',
    info : 'Фен',
    warrantyPeriod : '5 лет',
    warrantyTerms : 'Использование по назначению'
  }]

}