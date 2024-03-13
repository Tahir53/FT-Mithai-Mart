import 'package:flutter/material.dart';
import 'package:ftmithaimart/screens/homepage/home_page.dart';
import 'package:intl/intl.dart';

import '../model/cart_model.dart';

class ReceiptScreen extends StatelessWidget {
  final String orderId;
  final List<Cart> cartItems;
  final DateTime orderDateTime;
  final String name;
  final double totalAmount;

  const ReceiptScreen({
    Key? key,
    required this.orderId,
    required this.cartItems,
    required this.orderDateTime,
    required this.name,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Cart Items Length: ${cartItems.length}');
    cartItems.forEach((item) {
      print('Product Name: ${item.productName}, Quantity: ${item.formattedQuantity}');
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF63131C),
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
          child: Image.asset("assets/Logo.png", width: 50, height: 50
            // alignment: Alignment.center,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 10)),
                const Text(
                  "INVOICE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  title: Text('Order ID: $orderId'),
                ),
                ListTile(
                  title: Text('Order Date & Time: ${DateFormat(' E,d MMM y H:m').format(orderDateTime)}'),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return ListTile(
                      title: Text(cartItem.productName),
                      subtitle: Text('${cartItem.formattedQuantity} kgs'),
                      trailing: Text('Rs. ${cartItem.price}'),
                    );
                  },
                ),
                ListTile(
                  title: Text('Total Amount: Rs. ${totalAmount.toStringAsFixed(2)}'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => homepage(name: name),
                      ),
                    );
                  },
                  child: Text("Track Order"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}