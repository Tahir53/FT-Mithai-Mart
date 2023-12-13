import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:ftmithaimart/components/carousel_card.dart';
import 'package:ftmithaimart/components/category_container.dart';
import 'package:ftmithaimart/components/product_card.dart';
import 'package:ftmithaimart/components/search_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/drawer.dart';

class homepage extends StatefulWidget {

  final String name; 
  final String? email;
  final String? contact;
  homepage({required this.name, this.email, this.contact});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  // final TextEditingController _searchController = TextEditingController();
  final controller = PageController(initialPage: 0);
  String? text;
  String selectedCat = "classic";

  Future<String?> getData() async {
    var data = await SharedPreferences.getInstance();
    return data.getString("user");
  }

@override
  void initState() {
    super.initState();
    
    // getData().then((value) {
      // setState(() {
        // text = value;
      // });
    // });
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
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
        actions:  [
          IconButton(onPressed: (){}, icon: const Icon(Icons.local_grocery_store_outlined, color: Colors.white),),
        ],

        backgroundColor: const Color(0xff801924),
      ),
      drawer: CustomDrawer(name: widget.name, email: widget.email, contact: widget.contact),
      body:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
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
              const SizedBox(height: 20,),
              FlutterCarousel.builder(
                itemCount: 2, 
              itemBuilder: ((context, index, realIndex) {
                        // return widgetList[index];
                        return const CarouselCard();
                      }), options: CarouselOptions(
                        height: 200,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                    ),
               const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedCat = "classic";
                            });
                          },
                          child: CategoryContainer(categoryName: "Classic Sweets", selected: selectedCat == "classic" ? true : false,)),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedCat = "halwa";
                            });
                          },
                          child: CategoryContainer(categoryName: "Halwa Jaat", selected: selectedCat == "halwa" ? true : false,)),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            selectedCat = "malai";
                            setState(() {
                              
                            });
                          },
                          child: CategoryContainer(categoryName: "Malai Khaja", selected: selectedCat == "malai" ? true : false)),
                      ],
                    ),
                ),
              ),
              const SizedBox(height: 20,),
              const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("See All",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.right,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProductCard(assetPath: "assets/BadamPak.jpg", price: 1500, productName: "Badam Pak",),
                        ProductCard(assetPath: "assets/Mesub.jpg", price: 1300, productName: "Egg Mesub",),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: 
                      [
                        ProductCard(assetPath: "assets/Paira.jpg", price: 1250, productName: "Zafrani Paira",),
                        ProductCard(assetPath: "assets/GulaabJaman.jpg", price: 1000, productName: "Gulaab Jaman",),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,)
            ],
          ),
      ),
    );
  }
}
