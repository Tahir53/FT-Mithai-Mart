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
          title: const Text('Product Actions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showUpdateDialog(context, product, setStateCallback);
                },
                child: const Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDeleteDialog(context, product, setStateCallback);
                },
                child: const Text('Delete'),
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

    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());
    TextEditingController stockController =
        TextEditingController(text: product.stock.toString());
    TextEditingController descriptionController =
        TextEditingController(text: product.description);
    TextEditingController discountController =
        TextEditingController(text: product.discount.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Update Product'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stock'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Discount %'),
                ),
                DropdownButtonFormField<String>(
                  value: dropdownValue,
                  items: categoryValues
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    dropdownValue = newValue!;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    updateProduct(
                      context,
                      product,
                      setStateCallback,
                      nameController,
                      priceController,
                      stockController,
                      descriptionController,
                      discountController,
                      dropdownValue,
                    );
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
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
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                MongoDatabase.deleteProduct(product.id!.toHexString());
                Navigator.of(context).pop();
                _showDeletedMessage();
                setStateCallback();
              },
              child: const Text(
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
      backgroundColor: const Color(0xff63131C),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void _showDeletedMessage() {
    Fluttertoast.showToast(
      msg: 'Successfully Deleted',
      backgroundColor: const Color(0xff63131C),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void updateProduct(
      BuildContext context,
      Product product,
      VoidCallback setStateCallback,
      TextEditingController nameController,
      TextEditingController priceController,
      TextEditingController stockController,
      TextEditingController descriptionController,
      TextEditingController discountController,
      String dropdownValue) {
    int originalPrice = double.parse(priceController.text).truncate();
    double discount = double.parse(discountController.text);
    int discountedPrice =
        (originalPrice - (originalPrice * (discount / 100))).truncate();

    Product updatedProduct = Product(
      id: product.id,
      name: nameController.text,
      price: originalPrice.toString(),
      stock: double.parse(stockController.text),
      category: dropdownValue,
      image: product.image,
      quantity: [],
      description: descriptionController.text,
      discount: double.parse(discountController.text),
      discountedPrice: discountedPrice.toString(),
    );

    MongoDatabase.updateProduct(updatedProduct);
    Navigator.pop(context);
    _showUpdateMessage();
    setStateCallback();
  }
}
