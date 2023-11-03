from flask import Flask
from pymongo import MongoClient

app = Flask(__name__)
client = MongoClient("mongodb+srv://ftmart:omCgQjnJyECVnfOC@ftmart.yux7wpe.mongodb.net/?retryWrites=true&w=majority")
db = client.ft_mart  # Use the database directly, not get_database()

@app.route("/")
def hello_world():
    records = db.customer.find({"name": "Muhammad"})  
    result = []
    for record in records:
        print(record)
        result.append(record)
    return str(result)

if __name__ == "__main__":
    app.run(debug=True)