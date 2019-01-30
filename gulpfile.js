const { src, dest, parallel, series, watch } = require('gulp');
const nodemon = require('nodemon');
const path = require('path');

let stream = null;

function nodeStart () {
  stream = nodemon({
    script: './server/app.js',
    watch: ['server/*']
  })
  .on('restart', function () {
    console.log('restarted!');
  })
  .on('crash', function() {
    console.error('Application has crashed!\n')
     stream.emit('restart', 10)  // restart the server in 10 seconds
  })
}

function watchTask () {
  watch('server/*', function (cb) {
    stream.emit('restart');
    cb();
  })
}

exports.default = parallel(nodeStart);