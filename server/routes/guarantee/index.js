var express = require('express');
var router = express.Router();

router.get('/list', function (req, res) {
    res.render('guarantee/list.html');
});

router.get('/info/:gid', function (req, res) {
    res.render('guarantee/info.html');
});

module.exports = router;