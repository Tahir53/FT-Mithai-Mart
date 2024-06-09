import 'package:flutter/material.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';

class SearchTextField extends StatefulWidget {
  final Function(List)? onChanged;
  final TextEditingController controller;

  const SearchTextField({super.key, this.onChanged, required this.controller});

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  Future<List> _searchProducts(String query) async {
    final List<Map<String, Object?>> results =
        await MongoDatabase.searchProducts(query);
    setState(() {});
    return results;
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: widget.controller,
            onChanged: (query) async {
              widget.onChanged != null
                  ? widget.onChanged!(await _searchProducts(query))
                  : _searchProducts(query);
            },
            style: const TextStyle(
              fontFamily: 'Montserrat',
            ),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: const TextStyle(
                color: Color(0xFF6B4F02),
              ),
              suffixIcon: widget.controller.text.isEmpty
                  ? const Icon(
                      Icons.search,
                      color: Color(0xFF6B4F02),
                    )
                  : GestureDetector(
                      onTap: () {
                        widget.controller.text = "";
                        widget.onChanged != null
                            ? widget.onChanged!([])
                            : _searchProducts("");
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Color(0xFF6B4F02),
                      ),
                    ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
