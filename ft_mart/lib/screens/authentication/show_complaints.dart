import 'package:flutter/material.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';

import '../../components/admindrawer.dart';
import '../../components/drawer.dart';
import '../../model/complaints_model.dart';

class ShowComplain extends StatefulWidget {
  @override
  State<ShowComplain> createState() => _ShowComplainState();
}

class _ShowComplainState extends State<ShowComplain> {
  bool complainLoading = true;
  List<Complaint> complaints = [];

  void getComplain() async {
    complaints = await MongoDatabase.getComplaints();
    setState(() {
      complainLoading = false;
    });
  }

  @override
  void initState() {
    getComplain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(
            "assets/Logo.png",
            width: 50,
            height: 50,
          ),
        ),
        backgroundColor: const Color(0xff801924),
      ),
      drawer: AdminDrawer(name: "user"),
      body: complainLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: const Color(0xff801924),
            ))
          : ComplaintList(complaints: complaints),
    );
  }
}

class ComplaintList extends StatelessWidget {
  final List<Complaint> complaints;

  const ComplaintList({required this.complaints});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${complaints[index].name}"),
              Text("Email: ${complaints[index].email}"),
              Text("Contact: ${complaints[index].contact}"),
              Text("Description: ${complaints[index].description}"),
            ],
          ),
        );
      },
    );
  }
}
