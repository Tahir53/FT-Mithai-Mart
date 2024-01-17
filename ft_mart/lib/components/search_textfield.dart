import 'package:flutter/material.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';

class SearchTextField extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, Object?>> _searchResults = [];

  Future<void> _searchProducts(String query) async {
    final List<Map<String, Object?>> results = await MongoDatabase.searchProducts(query);
    print('Original Query: $query');
    // Use the results as needed
    print(results);

    // Optionally, you can assign the results to the _searchResults
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E6),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _controller,
            onChanged: (query) {
              _searchProducts(query);
            },
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Color(0xFF6B4F02),
              ),
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xFF6B4F02),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
