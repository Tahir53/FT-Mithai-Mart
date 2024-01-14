import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../dbHelper/mongodb.dart';
import '../model/product_model.dart';

class ProductDialogs {
  static void showUpdateDeleteDialog(
      BuildContext context, Product product, VoidCallback setStateCallback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Actions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showUpdateDialog(context, product, setStateCallback);
                },
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDeleteDialog(context, product, setStateCallback);
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showUpdateDialog(
      BuildContext context, Product product, VoidCallback setStateCallback) {
    String dropdownValue = product.category;
    List<String> categoryValues = [
      'Halwa Jaat',
      'Classic Sweets',
      'Malai Khaja'
    ];
    print(product.id);
    print(product.name);
    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());
    TextEditingController stockController =
        TextEditingController(text: product.stock.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
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
                  dropdownValue = newValue!;
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Product updatedProduct = Product(
                    id: product.id,
                    name: nameController.text,
                    price: priceController.text,
                    stock: double.parse(stockController.text),
                    category: dropdownValue,
                    image: product.image,
                    quantity: [],
                  );

                  MongoDatabase.updateProduct(updatedProduct);
                  Navigator.pop(context);
                  _showUpdateMessage();
                  setStateCallback();
                },
                child: Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showDeleteDialog(
      BuildContext context, Product product, VoidCallback setStateCallback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                MongoDatabase.deleteProduct(product.id!.toHexString());
                Navigator.of(context).pop();
                _showDeletedMessage();
                setStateCallback();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showUpdateMessage() {
    Fluttertoast.showToast(
      msg: 'Successfully Updated',
      backgroundColor: Color(0xff63131C),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void _showDeletedMessage() {
    Fluttertoast.showToast(
      msg: 'Successfully Deleted',
      backgroundColor: Color(0xff63131C),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
