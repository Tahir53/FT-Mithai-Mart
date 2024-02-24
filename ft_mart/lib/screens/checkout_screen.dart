import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/cart_item_tile.dart';
import '../components/total_card.dart';
import '../model/cart_model.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Cart> cartItems; // Change the type to List<Cart>
  final double totalAmount;

  const CheckoutScreen({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _forDelivery = false;
  bool _forPickup = false;
  DateTime? _pickupDateTime;

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
            Padding(padding: EdgeInsets.only(top: 10)),
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
                  'Pickup Details: ${DateFormat('MMM d, yyyy hh:mm a').format(_pickupDateTime!)}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateTimePicker() async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _pickupDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
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
