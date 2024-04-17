import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../dbHelper/mongodb.dart';
import '../model/product_model.dart';

class AdminAddProductScreen extends StatefulWidget {
  final VoidCallback onProductAdded;

  AdminAddProductScreen({required this.onProductAdded});

  @override
  _AdminAddProductScreenState createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  String dropdownValue = 'Halwa Jaat';
  List<String> categoryValues = ['Halwa Jaat', 'Classic Sweets', 'Malai Khaja'];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController =
      TextEditingController(text: '0.0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
        ),
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.all(0.0),
          child: Text(
            "Add Product",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xff63131C),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stock'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                value: dropdownValue,
                items: categoryValues
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
              ),
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Discount',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  check();
                  widget.onProductAdded();
                },
                icon: Icon(
                  Icons.inventory_outlined,
                  color: Color(0xFF63131C),
                ),
                label: Text(
                  "Add Product",
                  style: TextStyle(
                    color: Color(0xFF63131C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void check() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        stockController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      errormsg();
      return;
    } else {
      Navigator.of(context).pop();
      showSuccessMessage();
    }

    // Parse discount value
    double discount = double.tryParse(discountController.text) ?? 0.0;

    // Calculate discounted price
    double originalPrice = double.parse(priceController.text);
    double discountedPrice = originalPrice * (1 - discount / 100);

    // Create a new product
    Product newProduct = Product(
      name: nameController.text,
      price: priceController.text,
      // Use original price
      stock: double.parse(stockController.text),
      category: dropdownValue,
      image: '',
      // Add image URL if needed
      quantity: [0.5, 1],
      // Adjust as needed
      description: descriptionController.text,
      discount: discount,
      discountedPrice: discountedPrice.toStringAsFixed(0),
    );

    // Insert the new product
    await MongoDatabase.insertProduct(newProduct);

    // Clear text controllers
    nameController.clear();
    priceController.clear();
    stockController.clear();
    descriptionController.clear();
    discountController.clear();
  }

  void errormsg() {
    Fluttertoast.showToast(
      msg: "Please fill all fields",
      backgroundColor: Color(0xff63131C),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void showSuccessMessage() {
    Fluttertoast.showToast(
      msg: "Product Successfully Added",
      backgroundColor: Color(0xff63131C),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
