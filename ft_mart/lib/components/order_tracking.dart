import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import '../model/orders_model.dart';
import 'drawer.dart';

class OrderTracking extends StatefulWidget {
  final String name;

  const OrderTracking({Key? key, required this.name}) : super(key: key);

  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  String orderId = '';
  List<String> orderedItems = [];
  String status = '';

  Future<void> _trackOrder() async {
    if (orderId.isEmpty) {
      // Show toast for empty order ID
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

    List<Order> orders = await fetchOrders(); // Fetch orders from MongoDB

    bool isValidOrder = false;
    for (Order order in orders) {
      if (order.orderId == orderId) {
        setState(() {
          orderedItems = order.cartItems.map((item) => item.productName).toList();
          status = order.status;
        });
        isValidOrder = true;
        break;
      }
    }

    if (!isValidOrder) {
      // Show toast for invalid order ID
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
    // Call the MongoDB helper method to fetch orders
    return await MongoDatabase.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF63131C),
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
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  orderId = value;
                  // Reset orderedItems and status when a new order ID is entered
                  orderedItems = [];
                  status = '';
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _trackOrder,
              child: Text('Track Order'),
            ),
            SizedBox(height: 16),
            if (orderId.isNotEmpty && orderedItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: $orderId',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ordered Items:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: orderedItems
                        .map(
                          (item) => ListTile(
                        title: Text(item),
                        // You can add more information about the items here
                      ),
                    )
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
