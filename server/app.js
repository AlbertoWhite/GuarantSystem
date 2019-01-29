const fs = require('fs');
var express = require('express');
var nunjucks = require('nunjucks');
var app = express();
var bodyParser  = require('body-parser');
const path = require('path');

const routes = require('./routes');

var PATH_TO_TEMPLATES = path.join(__dirname, 'views') ;
nunjucks.configure(PATH_TO_TEMPLATES, {
   autoescape: true,
   express: app
});

// support parsing of application/json type post data
app.use(bodyParser.json());
//support parsing of application/x-www-form-urlencoded post data
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/static', express.static(path.join(__dirname, './static')));
app.use('/', routes);

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
