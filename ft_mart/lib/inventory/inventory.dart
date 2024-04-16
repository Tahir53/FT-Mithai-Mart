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

class _inventoryState extends State<inventory> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

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
                    builder: (context) => AdminAddProductScreen(
                        onProductAdded: _refreshInventory),
                  ));
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Classic Sweets',
            ),
            Tab(text: 'Halwa Jaat'),
            Tab(text: 'Malai Khaja'),
          ],
          indicatorColor: Colors.white,
          labelColor: Color(0xffffC937),
          unselectedLabelColor: Colors.white,
          labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
        ),
      ),
      drawer: AdminDrawer(
          name: widget.name, email: widget.email, contact: widget.contact),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductList('Classic Sweets'),
          _buildProductList('Halwa Jaat'),
          _buildProductList('Malai Khaja'),
        ],
      ),
    );
  }

  Widget _buildProductList(String category) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: MongoDatabase.getProductsByCategory(category),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF63131C)),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final List<Map<String, dynamic>> productsData = snapshot.data!;
          final List<Product> products = productsData.map((productData) => Product.fromJson(productData)).toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final Product product = products[index];
              return InkWell(
                onTap: () {
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
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                            'Price: Rs.${product.price}/kg | Stock: ${product.stock}kgs | Category: ${product.category} | Discount: ${product.discount}% | Discounted Price: Rs.${product.discountedPrice}'),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
  void _refreshInventory() {
    setState(() {
      // Refresh inventory logic
    });
  }
}
