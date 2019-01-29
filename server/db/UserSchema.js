const mongoose = require("mongoose");
const Schema = mongoose.Schema;
  
// установка схемы
const userScheme = new Schema({
    email: String,
    password: String
    //TODO key
});


module.exports = mongoose.model("User", userScheme);