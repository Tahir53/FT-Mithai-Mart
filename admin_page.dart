import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class admin extends StatefulWidget{
  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
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
  @override
  Widget build(BuildContext context) {
    String _admin = text as String;
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
               Icons.format_list_bulleted_outlined,
             ),
             title: const Text('All Orders',style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.w600,
             )),
             onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>admin()));
             },
           ),
           Padding(padding: EdgeInsets.only(top:10)),
           ListTile(
             iconColor: Color(0xff801924),
             textColor: Color(0xff801924),
             contentPadding: EdgeInsets.all(5),
             leading: Icon(
               Icons.inventory_2_outlined,
             ),
             title: const Text('Inventory',style: TextStyle(
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
               Icons.people_outline,
             ),
             title: const Text('Staff',style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.w600,
             )),
             onTap: () {
             },
           ),


           Padding(padding: EdgeInsets.only(top:10)),
           ListTile(
             iconColor: Color(0xff801924),
             textColor: Color(0xff801924),
             contentPadding: EdgeInsets.all(5),
             leading: Icon(
               Icons.comment_sharp,
             ),
             title: const Text('Complaints',style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.w600,
             )),
             onTap: () {
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
         child: Column(
             children: [
         Row(
         children: [
         Padding(padding: EdgeInsets.only(top: 80, left: 20)),
     Text(
       "Welcome, $_admin!",
       style: TextStyle(
         color: Colors.black,
         fontSize: 24,
         fontWeight: FontWeight.w600,
       ),
     )
     ],
   ),
    ],
    ),
    ),



   );
  }
}