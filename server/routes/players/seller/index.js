var express = require('express');
var router = express.Router();

router.get('/:seller_id', function (req, res) {
  res.render('/players/seller.html');
});

router.post('/:man_id/sell', function (req, res) {
  res.redirect('/players/seller/:man_id');
});

module.exports = router;