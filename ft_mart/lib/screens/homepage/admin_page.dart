import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/admindrawer.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:intl/intl.dart';

import '../../model/orders_model.dart';

class admin extends StatefulWidget {
  final String name;
  final String? email;
  final String? contact;

  admin({required this.name, this.email, this.contact});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
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
            // alignment: Alignment.center,
          ),
        ),
        backgroundColor: const Color(0xff801924),
      ),
      drawer: AdminDrawer(
          name: widget.name, email: widget.email, contact: widget.contact),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 10),
              child: Text(
                "Welcome, Admin!",
                style: TextStyle(
                  color: Color(0xFF63131C),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Using FutureBuilder to fetch and display orders
            FutureBuilder<List<Order>>(
              future: MongoDatabase.getOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for data, show a loading indicator
                  return Center(
                    child: CircularProgressIndicator(color: Color(0xFF63131C)),
                  );
                } else if (snapshot.hasError) {
                  // If an error occurs, display an error message
                  return Center(
                    child: Text('Error fetching orders: ${snapshot.error}'),
                  );
                } else {
                  // Once data is available, display the list of orders
                  List<Order> orders = snapshot.data ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: orders.map((order) {
                      return Card(
                        elevation: 5,
                        color: Color(0xffFFF8E6),
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Stack(
                          children: [
                            ListTile(
                              title: Text('Order No.: ${order.orderId}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${order.name}'),
                                  Text(
                                      '${DateFormat(' E,d MMM y | H:m').format(order.orderDateTime)}'),
                                  // Text('Delivery/Pickup: ${order.isDelivery ? 'Delivery' : 'Pickup'}'),
                                ],
                              ),
                              // onTap: () {
                              //   // Handle tapping on the order item if needed
                              // },
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: DropdownButton<String>(
                                value: 'In Process', // Set the default selected item
                                items: <String>['In Process', 'Ready for Pickup', 'Shipped', 'Delivered'].map((String value) {
                                  Color backgroundColor = value == 'In Process' ? Color(0xffA4202E) : (value == 'Ready for Pickup' ? Color(0xff038200) : Colors.white);
                                  Color textColor = value == 'In Process' || value == 'Ready for Pickup' ? Colors.white : Colors.black;
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      color: backgroundColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 10, // Set the text size to 10 pixels
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  // Implement your logic for dropdown menu selection
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
