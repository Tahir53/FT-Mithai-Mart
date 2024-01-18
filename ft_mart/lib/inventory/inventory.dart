import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/inventory/add_products.dart';
import 'package:ftmithaimart/inventory/update_delete_products.dart';
import '../components/admindrawer.dart';
import '../dbHelper/mongodb.dart';
import '../model/product_model.dart';

class inventory extends StatefulWidget {
  final String name;
  final String? email;
  final String? contact;

  inventory({required this.name, this.email, this.contact});

  @override
  State<inventory> createState() => _inventoryState();
}

class _inventoryState extends State<inventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(
            "assets/Logo.png",
            width: 50,
            height: 50,
            // alignment: Alignment.center,
          ),
        ),
        backgroundColor: const Color(0xff801924),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminAddProductScreen(onProductAdded: _refreshInventory),
                  ));
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      drawer: AdminDrawer(
          name: widget.name, email: widget.email, contact: widget.contact),
      body: FutureBuilder(
        future: MongoDatabase.getProducts(),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF63131C)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final Product product = products[index];
                return InkWell(
                  onTap: () {
                    // Show the update/delete dialog
                    ProductDialogs.showUpdateDeleteDialog(
                      context,
                      product,
                      () {
                        setState(() {});
                      },
                    );
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      children: [
                        Image.network(
                          product.image,
                          width: double.infinity, // Set the width to fill the card
                          height: 150, // Set the desired height for the image
                          fit: BoxFit.cover, // Adjust the image to cover the available space
                        ),
                        ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                              'Price: Rs.${product.price}/kg | Stock: ${product.stock}kgs | Category: ${product.category}'
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _refreshInventory() {
    setState(()  {
     MongoDatabase.getProducts();
    });
  }
}
