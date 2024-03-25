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
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
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
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
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
                  )
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
            descriptionController.text.isEmpty
        //  imageController.text.isEmpty)
        ) {
      errormsg();
      return;
    } else {
      Navigator.of(context).pop();
      showSuccessMessage();
    }

    // Create a new product
    Product newProduct = Product(
      name: nameController.text,
      price: priceController.text,
      stock: double.parse(stockController.text),
      category: dropdownValue,
      image: imageController.text,
      quantity: [0.5, 1],
      description: '',
    );

    await MongoDatabase.insertProduct(newProduct);

    nameController.clear();
    priceController.clear();
    stockController.clear();
    categoryController.clear();
    imageController.clear();
    descriptionController.clear();
  }

  void errormsg() {
    Fluttertoast.showToast(
        msg: "Please fill all fields",
        backgroundColor: Color(0xff63131C),
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  void showSuccessMessage() {
    Fluttertoast.showToast(
        msg: "Product Successfully Added",
        backgroundColor: Color(0xff63131C),
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }
}
