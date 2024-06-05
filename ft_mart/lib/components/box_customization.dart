// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/box_dropdown.dart';
import 'package:ftmithaimart/model/cart_model.dart';
import 'package:ftmithaimart/model/cart_provider.dart';
import 'package:provider/provider.dart';
import '../model/box_model.dart';

class BoxCustomizationPage extends StatefulWidget {
  final List<Cart> cartItems;

  const BoxCustomizationPage({Key? key, required this.cartItems})
      : super(key: key);

  @override
  _BoxCustomizationPageState createState() => _BoxCustomizationPageState();
}

class _BoxCustomizationPageState extends State<BoxCustomizationPage> {
  List<String> _selectedBoxDesigns = [];
  List<String> selectedRibbonDesigns = [];
  List<String> selectedWrappingDesign = [];
  List customizationOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedBoxDesigns =
        List.generate(widget.cartItems.length, (index) => 'None');
    selectedRibbonDesigns =
        List.generate(widget.cartItems.length, (index) => 'None');
    selectedWrappingDesign =
        List.generate(widget.cartItems.length, (index) => 'None');
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(String optionType) {
    List<CustomizationOption> filteredOptions = [];
    if (optionType == 'Box') {
      filteredOptions = [
        CustomizationOption(name: 'None', imageUrls: ['']),
        CustomizationOption(
            name: 'Box Design 1',
            imageUrls: ['https://i.ibb.co/LYqBTzf/box-1.jpg']),
        CustomizationOption(
            name: 'Box Design 2',
            imageUrls: ['https://i.ibb.co/HrZpgKZ/box-2-removebg-preview.png']),
        CustomizationOption(
            name: 'Box Design 3',
            imageUrls: ['https://i.ibb.co/VJByMNb/box-3.png'])
      ];
    } else if (optionType == 'Ribbon') {
      filteredOptions = [
        CustomizationOption(name: 'None', imageUrls: ['']),
        CustomizationOption(
            name: 'Ribbon Design 1',
            imageUrls: ['https://i.ibb.co/Smb4G4W/ribbon-1.png']),
      ];
    } else {
      filteredOptions = [
        CustomizationOption(name: 'None', imageUrls: ['']),
        CustomizationOption(
            name: 'Wrapping Design 1',
            imageUrls: ['https://i.ibb.co/k3qbGg9/empty-cart.png']),
      ];
    }
    return filteredOptions.map((option) {
      return DropdownMenuItem<String>(
        value: option.name,
        child: Row(
          children: [
            Text(option.name),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: option.imageUrls[0] != ""
                  ? Image.network(
                      option.imageUrls[0],
                      width: 50,
                      height: 50,
                    )
                  : null,
            ),
          ],
        ),
      );
    }).toList();
  }

  void updateCustomizationOption(
      String productName, String designType, String designID, int index) {
    int existingIndex = customizationOptions
        .indexWhere((element) => element['productName'] == productName);

    if (existingIndex != -1) {
      customizationOptions[existingIndex][designType] = designID;
    } else {
      // Add a new entry if no existing entry found
      customizationOptions.add({
        'productName': productName,
        designType: designID,
        'cartItemID': index
      });
    }

    print(customizationOptions);
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
            const Text(
              "Box Customization",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(widget.cartItems[index].productName),
                      subtitle:
                          Text('Quantity: ${widget.cartItems[index].quantity}'),
                    ),
                    BoxDropdown(
                        title: 'Box Design',
                        selectedValue: _selectedBoxDesigns[index],
                        items: _buildDropdownItems('Box'),
                        onChanged: (value) {
                          updateCustomizationOption(widget.cartItems[index].productName, 'boxDesignID', value!, index);
                          setState(() {
                            _selectedBoxDesigns[index] = value!;
                          });
                        }),
                    BoxDropdown(
                        title: 'Ribbon Design',
                        selectedValue: selectedRibbonDesigns[index],
                        items: _buildDropdownItems('Ribbon'),
                        onChanged: (value) {
                          updateCustomizationOption(widget.cartItems[index].productName, 'ribbonDesignID', value!, index);
                          setState(() {
                            selectedRibbonDesigns[index] = value!;
                          });
                        }),
                    BoxDropdown(
                        title: 'Wrapping Design',
                        selectedValue: selectedWrappingDesign[index],
                        items: _buildDropdownItems('Wrapping'),
                        onChanged: (value) {
                          updateCustomizationOption(widget.cartItems[index].productName, 'wrappingDesignID', value!, index);
                          setState(() {
                            selectedWrappingDesign[index] = value!;
                          });
                        }),
                    const Divider(),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<CartProvider>(context, listen: false).updateCustomize();
                Provider.of<CartProvider>(context, listen: false).updateCustomizationOptions(customizationOptions);
              },
              child: Text('Proceed with Customization'),
            ),
          ],
        ),
      ),
    );
  }
}
