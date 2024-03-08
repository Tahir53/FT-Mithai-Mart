import 'package:flutter/material.dart';
import 'package:ftmithaimart/model/cart_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/cart_item_tile.dart';
import '../components/reciepts_screen.dart';
import '../components/total_card.dart';
import '../dbHelper/mongodb.dart';
import '../model/cart_model.dart';
import '../model/orders_model.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Cart> cartItems; // Change the type to List<Cart>
  final double totalAmount;
  final String? name;
  final String? email;
  final String? contact;

  const CheckoutScreen(
      {Key? key,
      required this.cartItems,
      required this.totalAmount,
      required this.name,
      required this.email,
      required this.contact})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _forDelivery = false;
  bool _forPickup = false;
  DateTime? _pickupDateTime;
  final TextEditingController _addressController =
      TextEditingController(); // Controller for delivery address

  // Function to handle checkout process

  void _checkout() async {
    List<String> productNames = [];
    List<String> quantities = [];
    for (var item in widget.cartItems) {
      productNames.add(item.productName);
      quantities.add(item.formattedQuantity);
    }

    Order order = Order(
      orderId: Order.generateOrderId(),
      cartItems: widget.cartItems,
      totalAmount: widget.totalAmount,
      orderDateTime: _pickupDateTime ?? DateTime.now(),
      deliveryAddress: _forDelivery ? _addressController.text : "Pickup",
      name: widget.name ?? "user",
      email: widget.email ?? "no email",
      contact: widget.contact ?? "no contact",
      productNames: productNames,
      quantities: quantities,
    );

    // Save order to database
    await saveOrderToDatabase(order);

    if (context.mounted){
      Provider.of<CartProvider>(context, listen: false).clearCart();
      
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          name: order.name,
          orderId: order.orderId,
          cartItems: order.cartItems,
          orderDateTime: order.orderDateTime,
        ),
      ),
      (route) => false, // Remove all previous routes from the stack
    );
    }
    // Navigate to next screen after checkout
    
  }

  Future<void> saveOrderToDatabase(Order order) async {
    MongoDatabase.saveOrder(order);
  }

@override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10, bottom: 30)),
            Text(
              "Checkout",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            // Display Cart Items
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return CartItemTile(
                  productName: widget.cartItems[index].productName,
                  formattedQuantity: widget.cartItems[index].formattedQuantity,
                  price: widget.cartItems[index].price,
                  onTapDelete: () {},
                );
              },
            ),
            // Display Total Amount
            TotalCard(formattedTotal: widget.totalAmount.toString()),

            ListTile(
              title: Text('For Delivery'),
              leading: Radio(
                value: 'delivery',
                groupValue: _deliveryPickupGroupValue(),
                onChanged: (value) {
                  setState(() {
                    _forDelivery = true;
                    _forPickup = false;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  _forDelivery = true;
                  _forPickup = false;
                });
              },
            ),
            Visibility(
              visible: _forDelivery,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address for Delivery',
                        hintText: 'Enter your address',
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today), // Custom leading icon
                    title: Text(
                      'Select Delivery Date and Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward), // Custom trailing icon
                    onTap: () {
                      // Show date and time picker for delivery
                      // You can reuse the _showDateTimePicker function
                      _showDateTimePicker();
                    },
                  ),
                  if (_forDelivery && _pickupDateTime != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Delivery Details:\n'
                        '${DateFormat(' E,d MMM y H:m').format(_pickupDateTime!)}\n'
                        'Address: ${_addressController.text}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              title: Text('For Pickup'),
              leading: Radio(
                value: 'pickup',
                groupValue: _deliveryPickupGroupValue(),
                onChanged: (value) {
                  setState(() {
                    _forDelivery = false;
                    _forPickup = true;
                    _showDateTimePicker();
                  });
                },
              ),
              onTap: () {
                setState(() {
                  _forDelivery = false;
                  _forPickup = true;
                  // Show date and time picker
                  _showDateTimePicker();
                });
              },
            ),
            if (_forPickup && _pickupDateTime != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Pickup Details: ${DateFormat(' E,d MMM y H:m').format(_pickupDateTime!)}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ElevatedButton(
              onPressed: _checkout,
              // Call checkout function when button is pressed
              child: Text('Order'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateTimePicker() async {
    DateTime now = DateTime.now();
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      selectableDayPredicate: (DateTime date) {
        // Allow only weekdays (Monday to Saturday)
        return date.weekday != DateTime.sunday;
      },
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (combinedDateTime.hour >= 12 && combinedDateTime.hour <= 20) {
          setState(() {
            _pickupDateTime = combinedDateTime;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Pickup/Delivery time should be between 12 PM and 8 PM.'),
            ),
          );
        }
      }
    }
  }

  String? _deliveryPickupGroupValue() {
    if (_forDelivery) {
      return 'delivery';
    } else if (_forPickup) {
      return 'pickup';
    } else {
      return null;
    }
  }
}

// Utility function to calculate the total amount
double calculateTotal(List<Cart> items) {
  double total = 0;
  for (int i = 0; i < items.length; i++) {
    total += double.parse(items[i].price.replaceFirst("Rs.", "").trim());
  }
  return total;
}
