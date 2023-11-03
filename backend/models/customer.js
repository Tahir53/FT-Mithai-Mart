


const mongoose = require("mongoose")

const customerSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        trim: true  
    },
    password : {
        type: String
    },
    address: {
        type: String,
        required: true
    },
    contact: {
        type: String, 
        required: true
    },
})

const CustomerModel = mongoose.model("customer", customerSchema)
module.exports = CustomerModel