import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/admindrawer.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:intl/intl.dart';

import '../../model/orders_model.dart';
import '../../push_notifications.dart';

class admin extends StatefulWidget {
  final String name;
  final String? email;
  final String? contact;

  admin({required this.name, this.email, this.contact});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final List<Order>? fetchedOrders = await MongoDatabase.getOrders();
    if (fetchedOrders != null) {
      setState(() {
        orders = fetchedOrders;
      });
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final orderIndex = orders.indexWhere((order) => order.orderId == orderId);
    if (orderIndex != -1) {
      setState(() {
        orders[orderIndex].status = newStatus;
      });
      await MongoDatabase.updateOrderStatus(orderId, newStatus);

      Order order = orders[orderIndex];

      if (newStatus == 'Ready for Pickup') {
        await PushNotifications.sendNotification(
            orderId,
            order.deviceToken,
            'Order Ready for Pickup',
            'Your order with ID $orderId is ready for pickup!\nTrack Your Order By Clicking Here.'
        );
      } else if (newStatus == 'Ready for Delivery') {
        await PushNotifications.sendNotification(
            orderId,
            order.deviceToken,
            'Order Ready For Delivery',
            'Your order with ID $orderId is ready for delivery!\nRider on the Way! Track now.'
        );
      }

    }
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
            bottomRight: Radius.circular(16),
          ),
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
        name: widget.name,
        email: widget.email,
        contact: widget.contact,
      ),
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
            // Using ListView.builder to display orders
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 20),
                                Text('Order ID: ${order.orderId}'),
                                Text('Name: ${order.name}'),
                                Text('Email: ${order.email}'),
                                Text('Contact: ${order.contact}'),
                                Text('Pickup/Delivery Date & Time: ${DateFormat('E, d MMM y | hh:mm a').format(order.orderDateTime)}'),
                                Text('Delivery Address: ${order.deliveryAddress ?? 'N/A'}'),
                                Text('Total Amount: ${order.totalAmount}'),
                                Text('Payment Method: ${order.payment}'),
                                SizedBox(height: 10),
                                Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
                                ...List.generate(order.productNames.length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text('${order.productNames[index]} - ${order.quantities[index]} kg'),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Card(
                    elevation: 10,
                    color: Color(0xffFFF8E6),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Stack(
                      children: [
                        ListTile(
                          title: Text('Order No. ${order.orderId}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${order.name}'),
                              Text('${DateFormat(' E,d MMM y | hh:mm a').format(order.orderDateTime)}'),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: order.deliveryAddress == 'Pickup' ? Color(0xffFFEC8C) : Color(0xffFFEC8C),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              order.deliveryAddress == 'Pickup' ? 'Pickup' : 'Delivery',
                              style: TextStyle(color: Color(0xff8C7502)),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: DropdownButton<String>(
                            value: order.status,
                            items: <String>['In Process', 'Ready for Pickup', 'Ready for Delivery', 'Delivered'].map((String value) {
                              Color backgroundColor;
                              Color textColor;
                              switch (value) {
                                case 'In Process':
                                  backgroundColor = Color(0xffA4202E);
                                  textColor = Colors.white;
                                  break;
                                case 'Ready for Pickup':
                                  backgroundColor = Color(0xff038200);
                                  textColor = Colors.white;
                                  break;
                                case 'Ready for Delivery':
                                case 'Delivered':
                                  backgroundColor = Colors.white;
                                  textColor = Colors.black;
                                  break;
                                default:
                                  backgroundColor = Colors.white;
                                  textColor = Colors.black;
                              }
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  color: backgroundColor,
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              if (newValue != null) {
                                setState(() {
                                  order.status = newValue;
                                });
                                updateOrderStatus(order.orderId, newValue);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
