import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftmithaimart/components/rider_map.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:intl/intl.dart';
import '../model/orders_model.dart';
import 'drawer.dart';

class OrderTracking extends StatefulWidget {
  final String name;

  const OrderTracking({Key? key, required this.name}) : super(key: key);

  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  String name = '';
  String orderId = '';
  List<String> orderedItems = [];
  String status = '';
  double totalAmount = 0.0;
  String orderType = 'Delivery';
  DateTime? dateTime;

  Future<void> _trackOrder() async {
    if (orderId.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter an order ID",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    List<Order> orders = await fetchOrders();

    bool isValidOrder = false;
    for (Order order in orders) {
      if (order.orderId == orderId) {
        setState(() {
          name = order.name;
          orderedItems = order.cartItems
              .map((item) => "${item.productName} x ${item.quantity}kgs")
              .toList();
          status = order.status;
          totalAmount = order.totalAmount;
          orderType = (order.deliveryAddress != null &&
                  order.deliveryAddress!.toLowerCase() != "pickup")
              ? "Delivery"
              : "Pickup";
          dateTime = order.orderDateTime;
        });
        isValidOrder = true;
        break;
      }
    }

    if (!isValidOrder) {
      Fluttertoast.showToast(
        msg: "Invalid order ID",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<List<Order>> fetchOrders() async {
    return await MongoDatabase.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF63131C),
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
          ),
        ),
      ),
      drawer: CustomDrawer(
        name: widget.name,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Order ID',
                labelStyle: const TextStyle(color: Color(0xff63131C)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xff63131C)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  orderId = value;
                  orderedItems = [];
                  status = '';
                });
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _trackOrder,
                icon: const Icon(
                  Icons.track_changes_rounded,
                  color: Color(0xFF63131C),
                ),
                label: const Text(
                  "Track Order",
                  style: TextStyle(
                    color: Color(0xFF63131C),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (orderId.isNotEmpty && orderedItems.isNotEmpty)
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: $orderId',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(color: Color(0xFF63131C)),
                      const SizedBox(height: 10),
                      Text(
                        'Name: ${name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (dateTime != null)
                        Text(
                          'Order Date: ${DateFormat(' E,d MMM y | hh:mm a').format(dateTime!)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Text(
                        'Order Type: $orderType',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ordered Items:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...orderedItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(item),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Total Amount: Rs.${totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (status == 'In Process')
                        Image.network(
                          'https://i.ibb.co/grjzWpj/confirmed.gif',
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                        ),
                      if (status == 'Ready for Pickup')
                        Image.network(
                          'https://i.ibb.co/CVK0Ty0/Pickup.gif',
                          width: 150,
                          height: 150,
                          alignment: Alignment.center,
                        ),
                      if (status == 'Ready for Delivery')
                        Column(
                          children: [
                            Image.network(
                              'https://i.ibb.co/51gcgkg/delivery.gif',
                              width: 200,
                              height: 200,
                              alignment: Alignment.center,
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RiderMap(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Track Rider",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF63131C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 10),
                      if (status == 'Delivered')
                        Image.network(
                          'https://i.ibb.co/VN46xt2/delivered.gif',
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                        ),
                      const SizedBox(height: 16),
                      Text(
                        'Status: $status',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
