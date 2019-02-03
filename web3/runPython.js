const spawn = require("child_process").spawn;
const path = require('path');

module.exports = function (file, args) {
  const pythonProcess = spawn('python3', [path.join(__dirname, 'python', file)].concat(args));
  return new Promise((res, rej) => {
    pythonProcess.stdout.on('data', (data) => {
      res(data.toString());
    });
    pythonProcess.stderr.on('data', (data) => {
      rej(data.toString());
    });
  })


}