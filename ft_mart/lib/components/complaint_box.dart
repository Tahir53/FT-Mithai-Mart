import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/drawer.dart';
import '../dbHelper/complaintrepository.dart';
import '../dbHelper/mongodb.dart';
import '../model/complaints_model.dart';

class complaintbox extends StatefulWidget{
  final String? name;
  final String? email;
  complaintbox({this.name, this.email});

  @override
  State<complaintbox> createState() => _complaintboxState();
}

class _complaintboxState extends State<complaintbox> {
  final TextEditingController _complaintController = TextEditingController();
  bool complainLoading = false;


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(
            "assets/Logo.png",
            width: 50,
            height: 50,
            // alignment: Alignment.center,
          ),
        ),

        backgroundColor: const Color(0xff801924),
      ),
      drawer: CustomDrawer(name: "user",),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Please enter your complaint or feedback:',
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _complaintController,
              maxLines: 7,
              cursorColor: Color(0xff63131C),
              decoration: InputDecoration(
                hintText: "Type your complaint here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(width: 2, color: Color(0xff63131C)),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                // final complaintRepository = ComplaintRepository(MongoDatabase as MongoDatabase);

                // // Create a Complaint object with the entered data
                setState(() {
                  complainLoading = true;
                });
                final complaint = Complaint(
                  name: widget.name ?? "user",
                  email: widget.email ?? "no email",
                  description: _complaintController.text,
                );
                var result = await MongoDatabase.saveComplaint(complaint);
                if (result == 'Complaint submitted'){
                  _complaintController.text = "";
                  
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color(0xff63131C),
                  content: Text("Your complain has been submitted succesfully!", style: TextStyle(color: Colors.white),)
                  ));
                }

                else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color(0xff63131C),
                  content: Text(result, style: TextStyle(color: Colors.white),)
                  ));
                }
                setState(() {
                  complainLoading = false;
                });
                
                // // Save the complaint to MongoDB
                // await complaintRepository.saveComplaint(complaint);

                // // Navigate back or show a success message
                // Navigator.pop(context);
              },
              icon: const Icon(
                Icons.check_circle_outline_sharp,
                size: 24.0,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                  primary: Color(0xff801924),
                  fixedSize: Size(250, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              label: complainLoading ? SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(color: Colors.white,)) : const Text(
                "Submit",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  void submitComplaint(BuildContext context) {
    String complaint = _complaintController.text;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Complaint Submitted! Looking forward to serve you better!'),
          content: Text(complaint),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}