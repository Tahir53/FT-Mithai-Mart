
import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import '../constant.dart';
import '../model/complaints_model.dart';
import '../model/customer_model.dart';

class MongoDatabase{
  static var db, userCollection, complainCollection;
  
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
    complainCollection = db.collection('complaints');

  }

  static Future<String> insert(CustomerModel customer) async {
    try {
      var result = await userCollection.insertOne(customer.toJson());
      if (result.isSuccess){
        return "Data Inserted";
      } else {
        return "Something wrong while adding data";
      }
    } catch (e) {
      print(e.toString());
    }
    return "";
  }

  static Future<Map<String,dynamic>> getData(String email, String password) async {
    print("getdata() called in mongodb");
    final arrData = await userCollection.findOne({"email" : email});
    // print(arrData);
    if (arrData != null){
      if (arrData["password"] == password){
        return arrData;
      }
      else{
        return {"error" : "Invalid username or password"};
      }
      
    }
    return {"error" : "Invalid username or password"}; 
  }


  static Future<String> saveComplaint(Complaint complaint) async {
    var result = await complainCollection.insertOne(complaint.toJson());
    if (result.isSuccess){
      return "Complaint submitted";
    } else {
      return "Something wrong while adding data";
    }
  }

  static Future<List<Complaint>> getComplaints() async {
    List<Map<String, dynamic>> dataList = await complainCollection.find().toList();
    List<Complaint> complaints = [];
    for (var data in dataList){
      complaints.add(Complaint(
        name: data["name"],
        email: data["email"],
        description: data["description"],
      ));
    }
    return complaints;

  }

}