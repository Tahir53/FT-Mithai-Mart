import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final TextEditingController _searchController = TextEditingController();
  final controller = PageController(initialPage: 0);
  String? text;

  Future<String?> getData() async {
    var data = await SharedPreferences.getInstance();
    return data.getString("user");
  }


  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {
        text = value;
      });
    });
  }

  Widget build(BuildContext context) {
     String username = text as String;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        //automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
        ),
        flexibleSpace: Container(
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(top: 100)),
              Expanded(
                flex: 3,
                child: Image.asset(
                  "assets/Logo.png",
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                ),
              ),
              // const Expanded(
              //   flex: 1,
              //   child: Icon(Icons.local_grocery_store_outlined, color: Colors.white),
              // ),
            ],
          ),
        ),
        backgroundColor: const Color(0xff801924),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff801924),
              ),

              child: Image.asset("assets/Logo.png",scale: 7),
            ),
            Padding(padding: EdgeInsets.only(top:10)),
            ListTile(
              tileColor: Color(0xffE8BBBF),
              iconColor: Color(0xff801924),
              textColor: Color(0xff801924),
              contentPadding: EdgeInsets.all(5),
              leading: Icon(
                Icons.restaurant_menu,
              ),
              title: const Text('Menu',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
              },
            ),
            Padding(padding: EdgeInsets.only(top:10)),
            ListTile(
              iconColor: Color(0xff801924),
              textColor: Color(0xff801924),
              contentPadding: EdgeInsets.all(5),
              leading: Icon(
                Icons.comment,
              ),
              title: const Text('My Complaints',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            Padding(padding: EdgeInsets.only(top:10)),
            ListTile(
              iconColor: Color(0xff801924),
              textColor: Color(0xff801924),
              contentPadding: EdgeInsets.all(5),
              leading: Icon(
                Icons.info_outline,
              ),
              title: const Text('About Us',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
              },
            ),


            Padding(padding: EdgeInsets.only(top:10)),
            ListTile(
              iconColor: Color(0xff801924),
              textColor: Color(0xff801924),
              contentPadding: EdgeInsets.all(5),
              leading: Icon(
                Icons.privacy_tip_outlined,
              ),
              title: const Text('Privacy Policy',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
              },
            ),


            Padding(padding: EdgeInsets.only(top: 10)),
            ListTile(
              iconColor: Color(0xff801924),
              textColor: Color(0xff801924),
              contentPadding: EdgeInsets.all(5),
              leading: Icon(
                Icons.logout,
              ),
              title: const Text('Logout',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));
              },
            ),

          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(top: 80, left: 20)),
                  Text(
                    "Welcome, $username!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                      ),
                      onPressed: () => _searchController.clear(),
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Color(0xff6B4F02),
                      ),
                      onPressed: () {
                        // Perform the search here
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 230, left: 20, right: 20),
                  ),
                  Container(
                    width: 328,
                    height: 181,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
