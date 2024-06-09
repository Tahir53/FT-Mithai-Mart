import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:intl/intl.dart';
import '../components/admindrawer.dart';
import '../model/complaints_model.dart';
import '../push_notifications.dart';

class ShowComplain extends StatefulWidget {
  const ShowComplain({super.key});

  @override
  State<ShowComplain> createState() => _ShowComplainState();
}

class _ShowComplainState extends State<ShowComplain> {
  List<Complaint> ongoingComplaints = [];
  List<Complaint> completedComplaints = [];

  void getComplain() async {
    List<Complaint> updatedComplaints = await MongoDatabase.getComplaints();
    setState(() {
      ongoingComplaints =
          updatedComplaints.where((complaint) => !complaint.notified).toList();
      completedComplaints =
          updatedComplaints.where((complaint) => complaint.notified).toList();
    });
  }

  @override
  void initState() {
    getComplain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
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
          backgroundColor: const Color(0xff63131C),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ongoing'),
              Tab(text: 'Addressed'),
            ],
            indicatorColor: Colors.white,
            labelColor: Color(0xffffC937),
            unselectedLabelColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
          ),
        ),
        drawer: AdminDrawer(name: "user"),
        body: TabBarView(
          children: [
            ComplaintList(
                complaints: ongoingComplaints, refreshComplaints: getComplain),
            ComplaintList(
                complaints: completedComplaints,
                refreshComplaints: getComplain),
          ],
        ),
      ),
    );
  }
}

class ComplaintList extends StatefulWidget {
  final List<Complaint> complaints;
  final Function refreshComplaints;

  const ComplaintList(
      {super.key, required this.complaints, required this.refreshComplaints});

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.complaints.length,
      itemBuilder: (context, index) {
        Complaint complaint = widget.complaints[index];
        return Card(
          elevation: 8,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  _showOptionsDialog(context, index);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Complaint No. ${complaint.complaintId}"),
                      Text("Name: ${complaint.name}"),
                      Text("Email: ${complaint.email}"),
                      Text("Contact: ${complaint.contact}"),
                      Text("Description: ${complaint.description}"),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  DateFormat('E, d MMM y | hh:mm a').format(complaint.dateTime),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              if (complaint.notified)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildNotifiedTab(),
                ),
              if (!complaint.notified)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildWaitingTab(),
                ),
            ],
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
          title: const Text("Complaint Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () async {
                  if (complaint.id != null) {
                    await MongoDatabase.deleteComplaint(
                        complaint.id!.toHexString());
                    Navigator.of(context).pop();
                    _showDeletedMessage();
                    setState(() {});
                    widget.refreshComplaints();
                  }
                },
              ),
              if (!complaint.notified)
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notify'),
                  onTap: () async {
                    if (complaint.id != null) {
                      await PushNotifications.sendComplaintNotification(
                        complaint.complaintId,
                        complaint.deviceToken,
                        'Complaint Received for Complaint No. ${complaint.complaintId}',
                        'Dear Customer,\n'
                            'Your complaint has been received by our team and you will be contacted shortly.\n'
                            'We apologize for any inconvenience!',
                      );
                      await MongoDatabase.updateComplaint(complaint.id!, true);
                      setState(() {
                        widget.complaints[index].notified = true;
                      });
                      Navigator.of(context).pop();
                      _showSuccessMessage();
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotifiedTab() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "Notified",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildWaitingTab() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "Waiting",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  static void _showDeletedMessage() {
    Fluttertoast.showToast(
      msg: 'Successfully Deleted',
      backgroundColor: const Color(0xff63131C),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void _showSuccessMessage() {
    Fluttertoast.showToast(
      msg: 'Successfully Notified',
      backgroundColor: const Color(0xff63131C),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
