import 'package:ftmithaimart/dbHelper/mongodb.dart';
import '../model/complaints_model.dart';

class ComplaintRepository {
  final MongoDatabase _mongoDB;

  ComplaintRepository(this._mongoDB);

  Future<void> saveComplaint(Complaint complaint) async {
    final collection = MongoDatabase.db.collection('complaints');
    await collection.insertOne(complaint.toJson());
  }

  Future<List<Map<String, dynamic>>> getComplaints() async {
    final collection = MongoDatabase.db.collection('complaints');
    final cursor = await collection.find();
    final complaints = await cursor.toList();
    return complaints;
  }
}