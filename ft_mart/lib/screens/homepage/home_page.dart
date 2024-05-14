import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:ftmithaimart/components/box_customization.dart';
import 'package:ftmithaimart/components/cart_item_tile.dart';
import 'package:ftmithaimart/components/cart_sub_title.dart';
import 'package:ftmithaimart/components/first_carousel_card.dart';
import 'package:ftmithaimart/components/category_container.dart';
import 'package:ftmithaimart/components/product_card.dart';
import 'package:ftmithaimart/components/search_data_tile.dart';
import 'package:ftmithaimart/components/search_textfield.dart';
import 'package:ftmithaimart/components/total_card.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:ftmithaimart/model/cart_provider.dart';
import 'package:intl/intl.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/drawer.dart';
import '../../components/second_carousel_card.dart';
import '../../model/cart_model.dart';
import '../../model/product_model.dart';
import '../checkout_screen.dart';

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
    _scaffoldKey = GlobalKey<ScaffoldState>();
    MongoDatabase.getProducts();
  }

  final ScrollController _scrollController = ScrollController();
  String? text;
  String selectedCat = "Classic Sweets";
  late GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Cart> cart = [];
  List _searchResults = [];
  final TextEditingController searchController = TextEditingController();

  Future<String?> getData() async {
    var data = await SharedPreferences.getInstance();
    return data.getString("user");
  }

  bool shouldShowProduct(Product product) {
    return product.category == selectedCat;
  }

  void updateCart(String product, String price, double quantity) async {
    final stock = await MongoDatabase.getStock(product);
    if (stock == 0 || stock == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No Stock Available, please select another item!'),
          backgroundColor: Color(0xff63131C),
        ),
      );
    } else {
      await MongoDatabase.decreaseStock(product);
      Provider.of<CartProvider>(context, listen: false).addToCart(
          Cart(productName: product, price: price, quantity: quantity));
    }

    // setState(() {});
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFF8E6),
        onPressed: () async {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: ((context) => ChatPage())));
          try {
            dynamic conversationObject = {
              'appId': '11a65db28cf0b097c521704aba3748e24'
                  //'1ab9cf22e8c3fd473afac209140745943'
            };
            dynamic result = await KommunicateFlutterPlugin.buildConversation(
                conversationObject);
            print("Conversation builder success : " + result.toString());
          } on Exception catch (e) {
            print("Conversation builder error occurred : " + e.toString());
          }
        },
        child: const Icon(
          Icons.message,
          color: Color(0xff63131C),
        ),
      ),
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
          child: Image.asset("assets/Logo.png", width: 50, height: 50
              // alignment: Alignment.center,
              ),
        ),
        actions: [
          Consumer<CartProvider>(builder: (context, cartProvider, child) {
            if (cartProvider.items.isNotEmpty) {
              return GestureDetector(
                onTap: () => _scaffoldKey.currentState!.openEndDrawer(),
                child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Center(child: Builder(builder: (context) {
                      return Text(
                        cartProvider.items.length.toString(),
                        style: const TextStyle(
                            color: Color(0xff63131C),
                            fontWeight: FontWeight.bold),
                      );
                    }))),
              );
            }
            return const SizedBox();
          }),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.local_grocery_store_outlined),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
        backgroundColor: const Color(0xff63131C),
      ),
      drawer: CustomDrawer(
          name: widget.name, email: widget.email, contact: widget.contact),
      endDrawer: Drawer(
          backgroundColor: const Color(0xFFFFF8E6),
          child:
              Consumer<CartProvider>(builder: (context, cartProvider, child) {
            return SingleChildScrollView(
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
                  if (cartProvider.items.isEmpty) ...[
                    Image.network(
                      "https://i.ibb.co/k3qbGg9/empty-cart.png",
                      height: 100,
                      width: 50,
                    ),
                    const Text("Your Cart is Empty!"),
                  ] else if (cartProvider.items.isNotEmpty) ...[
                    displayCartSubTitles(),
                    displayCartItems(cartProvider),
                    const Padding(padding: EdgeInsets.only(top: 40)),
                    SizedBox(
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BoxCustomizationPage(cartItems: cartProvider.items)));
                            },
                            icon: const Icon(
                              Icons.dashboard_customize_outlined,
                              size: 24.0,
                              color: Colors.black,
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffffC937),
                                fixedSize: const Size(270, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            label: const Text(
                              "Customize Your Boxes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(
                                    cartItems: cartProvider.items,
                                    totalAmount:
                                        _calculateTotal(cartProvider.items),
                                    name: widget.name,
                                    email: widget.email,
                                    contact: widget.contact,
                                    loggedIn: widget.email != null,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.shopping_cart_checkout,
                              size: 24.0,
                              color: Colors.black,
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffffC937),
                                fixedSize: const Size(270, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            label: const Text(
                              "Proceed To Checkout",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ],
              ),
            );
          })),
      body: ListView(
        controller: _scrollController,
        children: [
          SingleChildScrollView(
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
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final result = _searchResults[index];
                              print(result);
                              return SearchDataField(
                                  name: result['name'],
                                  category: result['category'],
                                  price: result['price'].toString(),
                                  image: result['image'],
                                  stock: result['stock'],
                                  description: result['description'],
                                  discount: result['discount'],
                                  onPopupMenuButtonPressed: updateCart);
                            },
                          )
                        ],
                      )
                    : const SizedBox.shrink(),
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
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No data available.'),
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
                              discount: filteredProducts[i].discount ?? 0.0,
                              onTap: updateCart,
                            ),
                            if (i + 1 < filteredProducts.length)
                              ProductCard(
                                assetPath: filteredProducts[i + 1].image,
                                price: int.parse(filteredProducts[i + 1].price),
                                productName: filteredProducts[i + 1].name,
                                discount:
                                    filteredProducts[i + 1].discount ?? 0.0,
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

  Widget displayCartItems(cartProvider) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cartProvider.items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index < cartProvider.items.length) {
          final formattedQuantity = NumberFormat("#,##0.##")
              .format(cartProvider.items[index].quantity);

          return CartItemTile(
            productName: cartProvider.items[index].productName,
            formattedQuantity: formattedQuantity,
            price: cartProvider.items[index].price,
            showDeleteIcon: true,
            onTapDelete: () async {
              await MongoDatabase.addStock(
                  cartProvider.items[index].productName);
              cartProvider.removeFromCart(cartProvider.items[index]);
            },
          );
        } else {
          double total = 0;
          for (int i = 0; i < cartProvider.items.length; i++) {
            total += double.parse(
                cartProvider.items[i].price.replaceFirst("Rs.", "").trim());
          }
          final formattedTotal = NumberFormat("#,##0.00").format(total);

          return TotalCard(formattedTotal: formattedTotal);
        }
      },
    );
  }

  double _calculateTotal(List<Cart> items) {
    double total = 0;
    for (int i = 0; i < items.length; i++) {
      total += double.parse(items[i].price.replaceFirst("Rs.", "").trim());
    }
    return total;
  }
}
