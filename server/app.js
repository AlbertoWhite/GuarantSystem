const fs = require('fs');
var express = require('express');
var app = express();
var bodyParser  = require('body-parser');
const path = require('path');

const routes = require('./routes');

app.engine('html', function (filePath, options, callback) {
  fs.readFile(filePath, function (err, content) {
    if (err) return callback(new Error(err));
    return callback(null, content.toString());
  });
});
app.set('view engine', 'html');


// support parsing of application/json type post data
app.use(bodyParser.json());
//support parsing of application/x-www-form-urlencoded post data
app.use(bodyParser.urlencoded({ extended: true }));

app.set('views', path.join(__dirname, 'views'));
app.use('/static', express.static(path.join(__dirname, '../bundle')));
app.use('/', routes);

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
