import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:ftmithaimart/model/customer_model.dart';
import '../components/admindrawer.dart';
import '../model/complaints_model.dart';
import '../push_notifications.dart';

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
        iconTheme: IconThemeData(color: Colors.white),
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
          : ComplaintList(complaints: complaints, refreshComplaints: getComplain),
    );
  }
}

class ComplaintList extends StatefulWidget {
  final List<Complaint> complaints;
  final Function refreshComplaints;

  const ComplaintList({required this.complaints, required this.refreshComplaints});

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.complaints.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 8,
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              _showOptionsDialog(context, index);
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Complaint No. ${widget.complaints[index].complaintId}"),
                  Text("Name: ${widget.complaints[index].name}"),
                  Text("Email: ${widget.complaints[index].email}"),
                  Text("Contact: ${widget.complaints[index].contact}"),
                  Text("Description: ${widget.complaints[index].description}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOptionsDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Complaint complaint = widget.complaints[index];
        return AlertDialog(
          title: Text("Complaint Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () async {
                  if (complaint.id != null) {
                    await MongoDatabase.deleteComplaint(complaint.id!.toHexString());
                    Navigator.of(context).pop();
                    _showDeletedMessage();
                    setState(() {});
                    widget.refreshComplaints(); // Reload complaints after deleting
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notify'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showDeletedMessage() {
    Fluttertoast.showToast(
      msg: 'Successfully Deleted',
      backgroundColor: Color(0xff63131C),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
