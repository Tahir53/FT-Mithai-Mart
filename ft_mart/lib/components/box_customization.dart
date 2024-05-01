import 'package:flutter/material.dart';
import 'package:ftmithaimart/model/cart_model.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';

import '../model/box_model.dart';

class BoxCustomizationPage extends StatefulWidget {
  final List<Cart> cartItems;

  const BoxCustomizationPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _BoxCustomizationPageState createState() => _BoxCustomizationPageState();
}

class _BoxCustomizationPageState extends State<BoxCustomizationPage> {
  List<String?> _selectedBoxDesigns = [];
  List<String?> _selectedWrappingPapers = [];
  List<String?> _selectedRibbons = [];
  List<CustomizationOption> _customizationOptions = [];
  late Map<String, List<String>> _optionImages;

  @override
  void initState() {
    super.initState();
    if (widget.cartItems.isNotEmpty) {
      _selectedBoxDesigns = List.generate(widget.cartItems.length, (index) => null);
      _selectedWrappingPapers = List.generate(widget.cartItems.length, (index) => null);
      _selectedRibbons = List.generate(widget.cartItems.length, (index) => null);
    } else {
      // Handle the case where cartItems is empty
      print("Cart items is empty");
    }
    _fetchCustomizationOptions();
  }

  Future<void> _fetchCustomizationOptions() async {
    try {
      List<CustomizationOption> options = await MongoDatabase.getCustomizationOptions();
      Map<String, List<String>> optionImages = {};

      options.forEach((option) {
        optionImages[option.name] = option.imageUrls;
      });

      setState(() {
        _customizationOptions = options;
        _optionImages = optionImages;
      });
    } catch (e) {
      print("Error fetching customization options: $e");
    }
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(String optionType) {
    List<CustomizationOption> filteredOptions = _customizationOptions.where((option) => option.name == optionType).toList();

    return filteredOptions.map((option) {
      return DropdownMenuItem<String>(
        value: option.name,
        child: Row(
          children: [
            for (var imageUrl in option.imageUrls)
              Image.network(
                imageUrl,
                width: 100,
                height: 100,
              ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF63131C),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(
            "assets/Logo.png",
            width: 50,
            height: 50,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Box Customization",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),),
            SizedBox(height: 20,),
            // Display cart items with quantity and customization options
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(widget.cartItems[index].productName),
                      subtitle: Text('Quantity: ${widget.cartItems[index].quantity}'),
                    ),
                    // Customization options for each item
                    ListTile(
                      title: Text('Box Design'),
                      trailing: DropdownButton<String>(
                        value: _selectedBoxDesigns[index],
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBoxDesigns[index] = newValue;
                          });
                        },
                        items: _buildDropdownItems('Box Design'),

                      ),
                    ),
                    ListTile(
                      title: Text('Wrapping Paper'),
                      trailing: DropdownButton<String>(
                        value: _selectedWrappingPapers[index],
                        onChanged: (newValue) {
                          setState(() {
                            _selectedWrappingPapers[index] = newValue;
                          });
                        },
                        items: _buildDropdownItems('Wrapping Paper'),
                      ),
                    ),
                    ListTile(
                      title: Text('Ribbon'),
                      trailing: DropdownButton<String>(
                        value: _selectedRibbons[index],
                        onChanged: (newValue) {
                          setState(() {
                            _selectedRibbons[index] = newValue;
                          });
                        },
                        items: _buildDropdownItems('Ribbon'),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Proceed with customization
                for (int i = 0; i < widget.cartItems.length; i++) {
                  print('Item ${widget.cartItems[i].productName}: '
                      'Box Design: ${_selectedBoxDesigns[i]}, '
                      'Wrapping Paper: ${_selectedWrappingPapers[i]}, '
                      'Ribbon: ${_selectedRibbons[i]}');
                }
              },
              child: Text('Proceed with Customization'),
            ),
          ],
        ),
      ),
    );
  }
}
