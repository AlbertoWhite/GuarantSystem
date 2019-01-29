var passport       = require('passport');
var LocalStrategy  = require('passport-local').Strategy;
var User = require('./db/UserSchema');

passport.use(new LocalStrategy({
  usernameField: 'email'
}, function(username, done){
    User.findOne({ username : username},function(err,user){
        return err 
          ? done(err)
          : user
              ? done(null, user)
            : done(null, false, { message: 'Incorrect username.' });
      });
}));

passport.serializeUser(function(user, done) {
    done(null, user.id);
});
  
  
passport.deserializeUser(function(id, done) {
    User.findById(id, function(err,user){
        err 
          ? done(err)
          : done(null,user);
      });
});

module.exports.register = function(req, res, next) {
    var user = new User({ username: req.body.email});
    user.save(function(err) {
    return err
      ? next(err)
      : req.logIn(user, function(err) {
        return err
          ? next(err)
          : res.redirect('/guarantee/list');
      });
  });
};

module.exports.logout = function(req, res) {
    req.logout();
    res.redirect('/');
};

module.exports.login = function(req, res, next) {
    passport.authenticate('local',
    function(err, user, info) {
      return err 
        ? next(err)
        : user
          ? req.logIn(user, function(err) {
              return err
                ? next(err)
                : res.redirect('/guarantee/list');
            })
          : res.send('Произошла ошибка: ' + err.message);
    }
  )(req, res, next);
};

module.exports.mustAuthenticatedMw = function (req, res, next){
    req.isAuthenticated()
      ? next()
      : res.redirect('/signin');
  };