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


module.exports = {
    Vendor: mongoose.model("Vendor", playersScheme),
    Manufacturer: mongoose.model("Manufacturer", playersScheme),
    ServiceCenter: mongoose.model("ServiceCenter", playersScheme)
}