import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/complaint_box.dart';
import 'package:ftmithaimart/components/test.dart';
import '../screens/authentication/login_page.dart';
import 'about_us.dart';
import '../screens/homepage/home_page.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key, required this.name, this.email, this.contact});

  final String name;
  final String? email;
  final String? contact;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selectedtileindex = 0;

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
            child: Image.asset("assets/Logo.png", scale: 7),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            child: ListTile(
              tileColor: Color(0xffE8BBBF),
              iconColor: const Color(0xff801924),
              textColor: const Color(0xff801924),
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.restaurant_menu,
              ),
              title: const Text('Menu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onTap: () async {
                final result = await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => homepage(name: widget.name)));
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            child: ListTile(
              iconColor: const Color(0xff801924),
              textColor: const Color(0xff801924),
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.comment,
              ),
              title: const Text('My Complaints',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => complaintbox(
                              name: widget.name,
                              email: widget.email,
                              contact: widget.contact,
                            )));
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            child: ListTile(
              iconColor: const Color(0xff801924),
              textColor: const Color(0xff801924),
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.info_outline,
              ),
              title: const Text('About Us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => aboutus(name: "User")));
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Ink(
            child: ListTile(
              textColor: const Color(0xff801924),
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: Color(0xff801924),
              ),
              title: const Text('Privacy Policy',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Test())); //homepage(name: widget.name)));
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          ListTile(
            iconColor: const Color(0xff801924),
            textColor: const Color(0xff801924),
            contentPadding: const EdgeInsets.all(5),
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Logout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const login()));
            },
          ),
        ],
      ),
    );
  }

  void updateSelectedTile(int index) {
    setState(() {
      selectedtileindex = index;
    });
  }
}
