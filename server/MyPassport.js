var passport       = require('passport');
var LocalStrategy  = require('passport-local').Strategy;
var User = require('./db/UserSchema');

passport.use(new LocalStrategy({
  usernameField: 'email',
  passwordField: 'password'
}, function(email, password, done){
    User.findOne({ email : email },function(err,user){
        console.log(user);
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
    var user = new User({ email: req.body.email, password: 'pass'});
    User.findOne({ email : user.email },function(err, user_l){
        return err 
          ? done(err)
          : user_l
              ? next(new Error('User already exists.'))
            : user.save(function(err, user) {
                return err
                  ? next(err)
                  : req.logIn(user, function(err) {
                    return err
                      ? next(err)
                      : res.redirect('/guarantee/list');
                  });
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
          : res.redirect('/signin');
    }
  )(req, res, next);
};

module.exports.mustAuthenticatedMw = function (req, res, next){
    req.isAuthenticated()
      ? next()
      : res.redirect('/signin');
  };