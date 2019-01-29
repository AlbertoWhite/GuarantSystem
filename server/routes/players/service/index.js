var express = require('express');
var router = express.Router();

router.get('/:service_id', function (req, res) {
  res.render('/players/service.html');
});

module.exports = router;