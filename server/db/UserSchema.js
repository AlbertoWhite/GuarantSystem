const mongoose = require("mongoose");
const Schema = mongoose.Schema;
  
// установка схемы
const userScheme = new Schema({
    email: String,
    password: String,
    txAddress : String
});


module.exports = mongoose.model("User", userScheme);