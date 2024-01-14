import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:ftmithaimart/components/carousel_card.dart';
import 'package:ftmithaimart/components/category_container.dart';
import 'package:ftmithaimart/components/product_card.dart';
import 'package:ftmithaimart/components/search_textfield.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/drawer.dart';
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
  final ScrollController _scrollController = ScrollController();
  String? text;
  String selectedCat = "classic";

  Future<String?> getData() async {
    var data = await SharedPreferences.getInstance();
    return data.getString("user");
  }

  @override
  void initState() {
    super.initState();
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
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.local_grocery_store_outlined),
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
        child: Column(
          children: [
        DrawerHeader(
        child: Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
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
            // FlutterCarousel.builder(
            //   itemCount: 2,
            //   itemBuilder: ((context, index, realIndex) {
            //     return CarouselCard(
            //       scrollController: _scrollController,
            //     );
            //   }),
            //   options: CarouselOptions(
            //     height: 200,
            //     enableInfiniteScroll: true,
            //     autoPlay: true,
            //     enlargeCenterPage: true,
            //     autoPlayCurve: Curves.bounceInOut,
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCat = "classic";
                          });
                        },
                        child: CategoryContainer(
                            categoryName: "Classic Sweets",
                            selected: selectedCat == "classic")),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCat = "halwa";
                          });
                        },
                        child: CategoryContainer(
                            categoryName: "Halwa Jaat",
                            selected: selectedCat == "halwa")),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          selectedCat = "malai";
                          setState(() {});
                        },
                        child: CategoryContainer(
                            categoryName: "Malai Khaja",
                            selected: selectedCat == "malai")),
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
                  return Center(
                    child: CircularProgressIndicator(color: Color(0xFF63131C)),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching data: ${snapshot.error}'),
                  );
                } else {
                  List<Product> products = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < products.length; i += 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (i < products.length)
                                ProductCard(
                                  assetPath: products[i].image,
                                  price: int.parse(products[i].price),
                                  productName: products[i].name,
                                ),

                              if (i + 1 < products.length)
                                ProductCard(
                                  assetPath: products[i + 1].image,
                                  price: int.parse(products[i + 1].price),
                                  productName: products[i + 1].name,
                                ),
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
