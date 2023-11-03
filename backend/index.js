const mongoose = require("mongoose")
const express = require("express")
const bodyParser = require("body-parser")
const CustomerModel = require("./models/customer")

const app = express()
app.use(express.json())
app.use(bodyParser.json());

const PORT = 3000

const dbUrl = "mongodb+srv://ftmart:omCgQjnJyECVnfOC@ftmart.yux7wpe.mongodb.net/ftmart?retryWrites=true&w=majority"

const connectionParams = {
    useNewUrlParser: true,
    useUnifiedTopology: true
}

mongoose.connect(dbUrl, connectionParams).then(() => {
    console.info("Connected to FT Mart DB")
}).catch((e)=> {
    console.log("Error: ", e);
});

app.listen(PORT, () => {
    console.log(`Listening on PORT: ${PORT}`)
})

app.get("/insert", (req, res) => {
    var customerModel = new CustomerModel();
    customerModel.name = "Haider"
    customerModel.email = "haider@gmail.com"
    customerModel.address = "ph7"
    customerModel.contact = "03202907167",
    customerModel.password = "123"

    try{
        customerModel.save();
        res.status(200).send({"msg":"Inserted into DB"})
    }
    catch(err){
        console.log(err)
    }
})

app.get("/login", async (req, res) => {

    const {email, password} = req.query
    // console.log(email)
    try {
        const data = await CustomerModel.findOne({email: email});
        if (!data){
            return res.status(401).json({ error: "Invalid username or password" });
        }
        if (data.password === password) {
            res.status(200).json(data);
        } else {
            res.status(401).json({ error: "Invalid username or password" });
        }
        res.status(200).json(data);
    } catch (error) {
        res.status(500).json({ error: "Failed to fetch customers" });
    }

}); 
