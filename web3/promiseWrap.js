module.exports = function (f, args) {
  return new Promise ((res, rej) => {
    f.apply(null, args.concat((err, data) => {
      if (err) return rej(err);
      res(data);
    }))
  })
  .catch(console.error);
}