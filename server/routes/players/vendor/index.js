var express = require('express');
var router = express.Router();

router.get('/:id', function (req, res) {
  res.render('players/vendor.html');
});

module.exports = router;