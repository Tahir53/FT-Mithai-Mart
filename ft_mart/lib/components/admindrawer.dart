import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/complaint_box.dart';
import 'package:ftmithaimart/inventory/inventory.dart';
import 'package:ftmithaimart/inventory/update_delete_products.dart';
import '../screens/authentication/login_page.dart';
import '../complaints/show_complaints.dart';
import '../screens/homepage/about_us.dart';
import '../screens/homepage/admin_page.dart';
import '../screens/homepage/home_page.dart';

class AdminDrawer extends StatelessWidget {
  AdminDrawer({super.key, required this.name, this.email, this.contact});

  final String name;
  final String? email;
  final String? contact;

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
              iconColor: Color(0xff801924),
              textColor: Color(0xff801924),
              contentPadding: EdgeInsets.all(5),
              leading: Icon(
                Icons.format_list_bulleted_outlined,
              ),
              title: const Text('All Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => admin(
                              name: name,
                              email: email,
                              contact: contact,
                            )));
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            child: ListTile(
              iconColor: Color(0xff801924),
              textColor: Color(0xff801924),
              contentPadding: EdgeInsets.all(5),
              leading: Icon(
                Icons.inventory_2_outlined,
              ),
              title: const Text('Inventory',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => inventory(
                              name: 'admin',
                            )));
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            child: ListTile(
              iconColor: Color(0xff801924),
              textColor: Color(0xff801924),
              contentPadding: EdgeInsets.all(5),
              leading: Icon(
                Icons.people_outline,
              ),
              title: const Text('Staff',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          ListTile(
            iconColor: Color(0xff801924),
            textColor: Color(0xff801924),
            contentPadding: EdgeInsets.all(5),
            leading: Icon(
              Icons.comment_sharp,
            ),
            title: const Text('Complaints',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ShowComplain()));
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          ListTile(
            iconColor: Color(0xff801924),
            textColor: Color(0xff801924),
            contentPadding: EdgeInsets.all(5),
            leading: Icon(
              Icons.logout,
            ),
            title: const Text('Logout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => login()));
            },
          ),
        ],
      ),
    );
  }
}
