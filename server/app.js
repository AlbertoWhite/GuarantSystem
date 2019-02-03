const fs = require('fs');
var express = require('express');
var nunjucks = require('nunjucks');
var app = express();
var bodyParser  = require('body-parser');
const path = require('path');
const mongoose = require("mongoose");
var cookieParser = require('cookie-parser');
var cookieSession = require('cookie-session');
var passport       = require('passport');

const routes = require('./routes');

var PATH_TO_TEMPLATES = path.join(__dirname, 'views') ;
nunjucks.configure(PATH_TO_TEMPLATES, {
   autoescape: true,
   express: app
});

mongoose.connect(process.env.MONGODB_URI || "mongodb://heroku_0zdbrh08:pvmuqgam253ucpoo6nao4h529b@ds227481.mlab.com:27481/heroku_0zdbrh08", { useNewUrlParser: true });
// mongoose.on('connection', function (err) {
//   if (!err) console.log('db connected');
// })



// Middlewares, которые должны быть определены до passport:
app.use(cookieParser());
app.use(bodyParser());
app.use(cookieSession({ secret: Math.random().toString(32)+Math.random().toString(32) }));
 
// Passport:
app.use(passport.initialize());
app.use(passport.session());


// support parsing of application/json type post data
app.use(bodyParser.json());
//support parsing of application/x-www-form-urlencoded post data
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/static', express.static(path.join(__dirname, './static')));
app.use('/', routes);

app.listen(process.env.PORT || 3000, function () {
  console.log('App listening on port '+(process.env.PORT||3000));
  console.log('Click to open in browser: http://localhost:'+(process.env.PORT||3000));
});
