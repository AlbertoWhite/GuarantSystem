var express = require('express');
var router = express.Router();

router.get('/:id', function (req, res) {
  res.render('/players/serviceCenter.html');
});

module.exports = router;