var fs = require('fs');
var path = require('path');

module.exports = function (name) {
  var file = fs.readFileSync(path.join(__dirname, '../build/contracts', name+ '.sol'));
  return JSON.parse(file);
}