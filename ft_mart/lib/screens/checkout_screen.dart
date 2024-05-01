import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/jazz_cash/jazz_cash.dart';
import 'package:ftmithaimart/otp/phone_number/enter_number.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jazzcash_flutter/jazzcash_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/cart_item_tile.dart';
import '../components/reciepts_screen.dart';
import '../components/total_card.dart';
import '../dbHelper/mongodb.dart';
import '../model/cart_model.dart';
import '../model/orders_model.dart';
import '../push_notifications.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Cart> cartItems;
  final double totalAmount;
  final String? name;
  final String? email;
  final String? contact;
  final bool loggedIn;

  const CheckoutScreen({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
    required this.name,
    required this.email,
    required this.contact,
    required this.loggedIn,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _forDelivery = false;
  bool _forPickup = false;
  DateTime? _pickupDateTime;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  File? _receiptImage;
  String? _uploadedImageUrl;
  String? _paymentOption;

  Map payload = {};

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
      name: widget.loggedIn ? widget.name ?? "user" : _nameController.text,
      email: widget.email ?? "no email",
      contact: widget.contact ?? "no contact",
      productNames: productNames,
      quantities: quantities,
      payment: _paymentOption ?? "Cash on Delivery",
      receiptImagePath: _receiptImage != null ? _receiptImage!.path : null,
      deviceToken: await PushNotifications.returnToken(),
      status: 'In Process',
    );

    await saveOrderToDatabase(order);

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptScreen(
            name: order.name,
            orderId: order.orderId,
            cartItems: List<Cart>.from(widget.cartItems),
            orderDateTime: order.orderDateTime,
            totalAmount: widget.totalAmount,
          ),
        ),
        (route) => false,
      );
    }
    await _sendInAppNotification(order.orderId);
  }

  Future<void> saveOrderToDatabase(Order order) async {
    MongoDatabase.saveOrder(order);
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    final isNotLoggedIn = !widget.loggedIn;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF63131C),
        iconTheme: const IconThemeData(color: Colors.white),
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
            SizedBox(height: 20),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return CartItemTile(
                  productName: widget.cartItems[index].productName,
                  formattedQuantity: widget.cartItems[index].formattedQuantity,
                  price: widget.cartItems[index].price,
                  showDeleteIcon: false,
                  onTapDelete: () {},
                );
              },
            ),
            // Display Total Amount
            TotalCard(formattedTotal: widget.totalAmount.toString()),
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.grey,
                radioTheme: RadioThemeData(
                  fillColor: MaterialStateColor.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Color(0xff63131C);
                    }
                    return Colors.grey;
                  }),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Delivery'),
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
                        if (isNotLoggedIn)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: _nameController,
                              onChanged: (value) {
                                setState(() {
                                  _nameController.text = value;
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Color(0xff63131C)),
                                ),
                                labelText: "Enter Your Name",
                                labelStyle: TextStyle(
                                  color: Color(0xff63131C),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _addressController,
                            onChanged: (value) {
                              setState(() {
                                _addressController.text = value;
                              });
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff63131C)),
                              ),
                              labelText: "Enter Address For Delivery",
                              labelStyle: TextStyle(
                                color: Color(0xff63131C),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.calendar_today),
                          // Custom leading icon
                          title: Text(
                            'Select Delivery Date and Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward),
                          // Custom trailing icon
                          onTap: () {
                            _showDateTimePicker();
                          },
                        ),
                        if (_forDelivery && _pickupDateTime != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivery Details:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Delivery Date and Time: ${DateFormat(' E, d MMM y hh:mm a').format(_pickupDateTime!)}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Name: ${isNotLoggedIn ? _nameController.text : widget.name}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Delivery Address: ${_addressController.text}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  if (_paymentOption != null)
                                    Text(
                                      'Payment Mode: ${_paymentOption}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  SizedBox(height: 10),
                                  if (_paymentOption == 'EasyPaisa' &&
                                      _uploadedImageUrl != null)
                                    GestureDetector(
                                      onTap: () {
                                        launchUrl(_uploadedImageUrl! as Uri);
                                      },
                                      child: Text(
                                        'Uploaded Receipt',
                                        style: TextStyle(
                                          color: Color(0xff63131C),
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        Visibility(
                          visible: _forDelivery && _pickupDateTime != null,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Text('Payment Method: '),
                                DropdownButton<String>(
                                  value: _paymentOption,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _paymentOption = value;
                                    });
                                  },
                                  items: <String>[
                                    'Cash on Delivery',
                                    'EasyPaisa',
                                    'JazzCash'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_paymentOption == 'EasyPaisa')
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Transfer Money to: 0300XXXXXXX'),
                                ElevatedButton(
                                  onPressed: () {
                                    _uploadReceiptImage();
                                  },
                                  child: Text('Upload Receipt Image'),
                                ),
                                if (_uploadedImageUrl != null) ...[
                                  GestureDetector(
                                    onTap: () {
                                      launchUrl(_uploadedImageUrl! as Uri);
                                    },
                                    child: Text(
                                      'Uploaded Receipt',
                                      style: TextStyle(
                                          color: Color(0xff63131C),
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        if (_paymentOption == 'JazzCash')
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JazzCash()));
                                  },
                                  child: Text("Pay via Jazzcash"),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Pickup'),
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
                        _showDateTimePicker();
                      });
                    },
                  ),
                  if (_forPickup && _pickupDateTime != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Pickup Details: ${DateFormat(' E,d MMM y hh:mm a').format(_pickupDateTime!)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (_forPickup && !widget.loggedIn)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {
                            _nameController.text = value;
                          });
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xff63131C)),
                          ),
                          labelText: "Enter Your Name",
                          labelStyle: TextStyle(
                            color: Color(0xff63131C),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff63131C),
                      fixedSize: const Size(200, 40),
                    ),
                    onPressed: () {
                      if (!_forDelivery && !_forPickup) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please select either "Delivery" or "Pickup" option.'),
                            backgroundColor: Color(0xff63131C),
                          ),
                        );
                        return;
                      }

                      if (_forDelivery &&
                          (_addressController.text.isEmpty ||
                              _pickupDateTime == null)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please enter the details and select delivery date and time.'),
                            backgroundColor: Color(0xff63131C),
                          ),
                        );
                        return;
                      }
                      if (_forPickup && _pickupDateTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please select pickup date and time.'),
                            backgroundColor: Color(0xff63131C),
                          ),
                        );
                        return;
                      }
                      if (_forDelivery && _paymentOption == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a payment method.'),
                            backgroundColor: Color(0xff63131C),
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnterNumber(
                              function: () {
                                _checkout();
                              },
                            ),
                          ));
                    },
                    icon: Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Place Order',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
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

        if (combinedDateTime.isAfter(now) ||
            (combinedDateTime.day == now.day &&
                combinedDateTime.hour > now.hour &&
                combinedDateTime.hour <= 20)) {
          setState(() {
            _pickupDateTime = combinedDateTime;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Orders cannot be placed for previous timings or after 8 PM!',
              ),
              backgroundColor: Color(0xff63131C),
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

  Future<void> _uploadReceiptImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _receiptImage = File(pickedImage.path);
        _uploadedImageUrl = pickedImage.path;
      });
    } else {
      // Handle if user cancels image picking
    }
  }

  Future<void> _sendInAppNotification(String orderId) async {
    await PushNotifications.returnToken();
    final notificationTitle = 'Order Placed';
    final notificationBody =
        'Your order with ID $orderId has been successfully placed.';

    // Show in-app notification
    await PushNotifications.showSimpleNotification(
      title: notificationTitle,
      body: notificationBody,
      payload: 'order',
    );
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

class JazzCash extends StatefulWidget {
  const JazzCash({super.key});

  @override
  State<JazzCash> createState() => _JazzCashState();
}

class _JazzCashState extends State<JazzCash> {

  String paymentStatus = "pending";
  ProductModel productModel = ProductModel("Product 1", "100");
  String integritySalt= "81uc45cu80";
  String merchantID= "MC92142";
  String merchantPassword = "yf2su410d5";
  String transactionUrl= 'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JazzCash Flutter Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Product Name : ${productModel.productName}"),
            Text("Product Price : ${productModel.productPrice}"),
            ElevatedButton(onPressed: () {
              _payViaJazzCash(productModel, context);
            }, child: const Text("Purchase Now !"))
          ],
        ),
      ),
    );
  }

  Future<void> _payViaJazzCash(ProductModel product, BuildContext context) async {
    try {
      JazzCashFlutter jazzCashFlutter = JazzCashFlutter(
        merchantId: merchantID,
        merchantPassword: merchantPassword,
        integritySalt: integritySalt,
        isSandbox: true,
      );

      DateTime date = DateTime.now();

      JazzCashPaymentDataModelV1 paymentDataModelV1 = JazzCashPaymentDataModelV1(
        ppAmount: '${product.productPrice}',
        ppBillReference: 'refbill${date.year}${date.month}${date.day}${date.hour}${date.millisecond}',
        ppDescription: 'Product details ${product.productName} - ${product.productPrice}',
        ppMerchantID: merchantID,
        ppPassword: merchantPassword,
        ppReturnURL: transactionUrl,
      );

      await jazzCashFlutter.startPayment(paymentDataModelV1: paymentDataModelV1, context: context);

      setState(() {
        paymentStatus = "success"; // Update payment status if payment is successful
      });
    } catch (err) {
      print("Error in payment $err");
      // Handle error here
      setState(() {
        paymentStatus = "failed"; // Update payment status if payment fails
      });
    }
  }

}

class ProductModel {
  String? productName;
  String? productPrice;

  ProductModel(this.productName, this.productPrice);
}
