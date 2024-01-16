import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:ftmithaimart/components/first_carousel_card.dart';
import 'package:ftmithaimart/components/category_container.dart';
import 'package:ftmithaimart/components/product_card.dart';
import 'package:ftmithaimart/components/search_textfield.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/drawer.dart';
import '../../components/second_carousel_card.dart';
import '../../model/cart_model.dart';
import '../../model/product_model.dart';

class homepage extends StatefulWidget {
  final String name;
  final String? email;
  final String? contact;

  homepage({required this.name, this.email, this.contact});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  void initState() {
    super.initState();
    loadDataFromSharedPreference();
  }

  final ScrollController _scrollController = ScrollController();
  String? text;
  String selectedCat = "Classic Sweets";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Cart> cart = [];

  loadDataFromSharedPreference() async {
    var data = await SharedPreferences.getInstance();
    var cartData = data.getString("cart");
    if (cartData != null) {
      cart = jsonDecode(cartData);
    }
  }

  Future<String?> getData() async {
    var data = await SharedPreferences.getInstance();
    return data.getString("user");
  }

  saveCartInSharedPrefence() async {
    var data = await SharedPreferences.getInstance();
    data.setString("cart", jsonEncode(cart));
  }

  bool shouldShowProduct(Product product) {
    return product.category == selectedCat;
  }

  void updateCart(String product, String price, double quantity) {
    cart.add(Cart(productName: product, price: price, quantity: quantity));
    saveCartInSharedPrefence();
    setState(() {});
    // _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
          child: Image.asset(
            "assets/Logo.png",
            width: 50,
            height: 50,
            // alignment: Alignment.center,
          ),
        ),
        actions: [
          if (cart.isNotEmpty) GestureDetector(
            onTap: () => _scaffoldKey.currentState!.openEndDrawer(),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
              child: Center(child: Text(cart.length.toString(),style: const TextStyle(color: Color(0xff801924), fontWeight: FontWeight.bold),))
            ),
          ),
          Builder(
            builder: (context) =>
                IconButton(
                  icon: const Icon(Icons.local_grocery_store_outlined),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
          ),
        ],
        backgroundColor: const Color(0xff801924),
      ),
      drawer: CustomDrawer(
          name: widget.name, email: widget.email, contact: widget.contact),
      endDrawer: Drawer(
        backgroundColor: Color(0xFFFFF8E6),
        child: Column(
          children: [
            const DrawerHeader(
              child: Text(
                'CART',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black87,
                ),
              ),
            ),
            if (cart.isEmpty) ...[
              Image.network(
                "https://i.ibb.co/k3qbGg9/empty-cart.png",
                height: 100,
                width: 50,
              ),
              Text("Your Cart is Empty!"),
            ] else
              if (cart.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Quantity",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Price",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Color(0xff801924),
                      elevation: 5,
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            // Expanded(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text(
                            cart[index].productName,
                            style: TextStyle(color: Colors.white,),
                      ),
                      Text(
                        '${cart[index].quantity.toString()}kgs',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Rs.${cart[index].price}',
                        style: TextStyle(color: Colors.white),
                      ),
                      ],
                    ),
                    // ),

                    GestureDetector(
                    onTap: () {
                    setState(() {
                    cart.removeAt(index);
                    });
                    },
                    child: Icon(Icons.delete,color: Colors.white,),
                    ),
                    ],
                    ),
                    ),
                    );
                  },
                ),
              ],
          ],
        ),
      ),

      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 10),
              child: Text(
                "Welcome, ${widget.name}!",
                style: const TextStyle(
                  color: Color(0xFF63131C),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SearchTextField(),
            const SizedBox(
              height: 20,
            ),
            FlutterCarousel.builder(
              itemCount: 2,
              itemBuilder: ((context, index, realIndex) {
                if (index == 0) {
                  return FirstCarouselCard(
                    scrollController: _scrollController,
                  );
                } else if (index == 1) {
                  return SecondCarouselCard();
                }
                return const SizedBox.shrink();
              }),
              options: CarouselOptions(
                height: MediaQuery
                    .sizeOf(context)
                    .height * 0.28,
                enableInfiniteScroll: true,
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayCurve: Curves.bounceInOut,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCat = "Classic Sweets";
                          });
                        },
                        child: CategoryContainer(
                            categoryName: "Classic Sweets",
                            selected: selectedCat == "Classic Sweets")),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCat = "Halwa Jaat";
                          });
                        },
                        child: CategoryContainer(
                            categoryName: "Halwa Jaat",
                            selected: selectedCat == "Halwa Jaat")),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          selectedCat = "Malai Khaja";
                          setState(() {});
                        },
                        child: CategoryContainer(
                            categoryName: "Malai Khaja",
                            selected: selectedCat == "Malai Khaja")),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "See All",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Product>>(
              future: MongoDatabase.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF63131C)),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching data: ${snapshot.error}'),
                  );
                } else {
                  List<Product> products = snapshot.data!;
                  List<Product> filteredProducts = products
                      .where((product) => product.category == selectedCat)
                      .toList();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < filteredProducts.length; i += 2)
                          Row(
                            mainAxisAlignment:
                            filteredProducts.length % 2 == 1 &&
                                i == filteredProducts.length - 1
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.center,
                            children: [
                              ProductCard(
                                assetPath: filteredProducts[i].image,
                                price: int.parse(filteredProducts[i].price),
                                productName: filteredProducts[i].name,
                                onTap: updateCart,
                              ),
                              if (i + 1 < filteredProducts.length)
                                ProductCard(
                                  assetPath: filteredProducts[i + 1].image,
                                  price:
                                  int.parse(filteredProducts[i + 1].price),
                                  productName: filteredProducts[i + 1].name,
                                  onTap: updateCart,
                                ),
                              if (i + 1 >= filteredProducts.length)
                                const SizedBox(
                                  width: 180,
                                  height: 280,
                                )
                            ],
                          ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
