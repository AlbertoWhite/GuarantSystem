const mongoose = require("mongoose");
const Schema = mongoose.Schema;
  
// установка схемы
const playersScheme = new Schema({
    publickKey: String,
    secretKey: String,
    txAddress: String,
    name: String,
    realAddress: String,
    regNumber: String
});


module.exports = mongoose.model("playersScheme", playersScheme);