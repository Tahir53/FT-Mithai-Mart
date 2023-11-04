import 'package:flutter/material.dart';

import '../screens/authentication/login_page.dart';
import '../screens/homepage/home_page.dart';

class CustomDrawer extends StatelessWidget {
  
  final String name;
  const CustomDrawer({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff801924),
              ),

              child: Image.asset("assets/Logo.png",scale: 7),
            ),
            const Padding(padding: EdgeInsets.only(top:10)),
            ListTile(
              tileColor: const Color(0xffE8BBBF),
              iconColor: const Color(0xff801924),
              textColor: const Color(0xff801924),
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.restaurant_menu,
              ),
              title: const Text('Menu',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage(name: name,)));
              },
            ),
            const Padding(padding: EdgeInsets.only(top:10)),
            ListTile(
              iconColor: const Color(0xff801924),
              textColor: const Color(0xff801924),
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
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

            const Padding(padding: EdgeInsets.only(top:10)),
            ListTile(
              iconColor: const Color(0xff801924),
              textColor: const Color(0xff801924),
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.info_outline,
              ),
              title: const Text('About Us',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage(name: name,)));
              },
            ),


            const Padding(padding: EdgeInsets.only(top:10)),
            ListTile(
              iconColor: const Color(0xff801924),
              textColor: const Color(0xff801924),
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.privacy_tip_outlined,
              ),
              title: const Text('Privacy Policy',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage(name:name)));
              },
            ),


            const Padding(padding: EdgeInsets.only(top: 10)),
            ListTile(
              iconColor: const Color(0xff801924),
              textColor: const Color(0xff801924),
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('Logout',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const  login()));
              },
            ),

          ],
        ),
      );
  }
}