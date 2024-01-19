import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:ftmithaimart/components/first_carousel_card.dart';
import 'package:ftmithaimart/components/category_container.dart';
import 'package:ftmithaimart/components/product_card.dart';
import 'package:ftmithaimart/components/search_textfield.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:intl/intl.dart';
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
  List _searchResults = [];
  final TextEditingController searchController = TextEditingController();

  loadDataFromSharedPreference() async {
    print("Loading Data from Shared Preference");
    var data = await SharedPreferences.getInstance();
    var cartData = data.getString("cart");
    if (cartData != null) {
      List temp = [];
      temp = jsonDecode(cartData);
      temp.map((e) => cart.add(e),);
      setState(() {
        
      });
      
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

  void getSearchResults(List result) {
    setState(() {
      _searchResults = result;
    });
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
            height: 50
            // alignment: Alignment.center,
          ),
        ),
        actions: [
          if (cart.isNotEmpty)
            GestureDetector(
              onTap: () => _scaffoldKey.currentState!.openEndDrawer(),
              child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Center(
                      child: Text(
                    cart.length.toString(),
                    style: const TextStyle(
                        color: Color(0xff801924), fontWeight: FontWeight.bold),
                  ))),
            ),
          Builder(
            builder: (context) => IconButton(
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
            ] else if (cart.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                itemCount: cart.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < cart.length) {
                    final formattedQuantity =
                        NumberFormat("#,##0.##").format(cart[index].quantity);

                    return Card(
                      color: Color(0xff801924),
                      elevation: 5,
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Text(
                                cart[index].productName,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 40),
                            Expanded(
                              child: Text(
                                '$formattedQuantity kgs',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Text(
                              'Rs.${cart[index].price}',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  cart.removeAt(index);
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    double total = 0;
                    for (int i = 0; i < cart.length; i++) {
                      total += double.parse(
                          cart[i].price.replaceFirst("Rs.", "").trim());
                    }
                    final formattedTotal =
                        NumberFormat("#,##0.00").format(total);

                    return Card(
                      semanticContainer: false,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: const Color(0xffffC937),
                      elevation: 10,
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rs.$formattedTotal',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
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
                SearchTextField(
                  onChanged: getSearchResults,
                  controller: searchController,
                ),
                (_searchResults.isNotEmpty && searchController.text.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Search Results:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF63131C),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final result = _searchResults[index];
                              return InkWell(
                                  onTap: () {

                                  },

                                  child: Card(
                                    color: Color(0xFF63131C),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    result['name'] ?? '',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Category: ${result['category']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Price: Rs.${result['price']}/kg',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20,),
                                                  Text(
                                                    'Tap For Description',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Image.network(
                                                    result['image'],
                                                    width: 80,
                                                    height: 100,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 15.0),
                                                    child: buildPopupMenuButton(
                                                      result['name'].toString(),
                                                      int.parse(result['price']),
                                                      result['stock'],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              );
                            },
                          )


                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
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
              height: MediaQuery.sizeOf(context).height * 0.28,
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
                          mainAxisAlignment: filteredProducts.length % 2 == 1 &&
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
                                price: int.parse(filteredProducts[i + 1].price),
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
    );
  }

  Widget buildPopupMenuButton(String product, int price, double quantity) {



    return PopupMenuButton<double>(
      color: Color(0xFFFFF8E6),
      onSelected: (value) {
        num calculatedPrice = value == 0.5 ? price * 0.5 : price;
        updateCart(product, price.toString(), value);
      },
      itemBuilder: (BuildContext context) {
        return [1.0, 0.5].map((double choice) {
          // Calculate the price for each choice
          num calculatedPrice = choice == 0.5 ? price * 0.5 : price;

          return PopupMenuItem<double>(
            value: choice,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF63131C),
                    width: 2.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$choice kg',
                    style: const TextStyle(
                      color: Color(0xFF63131C),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  // Displaying the calculated price
                  Text(

                    'Rs.${calculatedPrice.toString()}',
                    style: const TextStyle(
                      color: Color(0xFF63131C),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
      child: Column(
        children: [
          const Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
            size: 28,
          ),
          Container(
            padding: const EdgeInsets.only(left: 7),
            width: 40,
            child: const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 8.0,
                color: Color(0xFF212121),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
