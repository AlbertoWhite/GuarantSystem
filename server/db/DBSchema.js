const mongoose = require("mongoose");
const Schema = mongoose.Schema;
  
// установка схемы
const playersScheme = new Schema({
    publicKey: String,
    secretKey: String,
    txAddress: String,
    name: String,
    physicalAddress: String,
    registrationNumber: String
});


module.exports = {
    Vendor: mongoose.model("Vendor", playersScheme),
    Manufacturer: mongoose.model("Manufacturer", playersScheme),
    ServiceCenter: mongoose.model("ServiceCenter", playersScheme)
}