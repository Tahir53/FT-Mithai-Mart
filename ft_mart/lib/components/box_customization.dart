import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/box_dropdown.dart';
import 'package:ftmithaimart/model/cart_model.dart';
import 'package:ftmithaimart/model/cart_provider.dart';
import 'package:provider/provider.dart';
import '../model/box_model.dart';
import '../screens/checkout_screen.dart';

class BoxCustomizationPage extends StatefulWidget {
  final List<Cart> cartItems;
  final String name;
  final String? email;
  final String? contact;

  const BoxCustomizationPage(
      {Key? key,
      required this.cartItems,
      required this.name,
      this.email,
      this.contact})
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
        CustomizationOption(name: 'None', value: 'None', imageUrls: ['']),
        CustomizationOption(name: 'Box Design 1', value: 'B001', imageUrls: [
          'https://i.ibb.co/L6MG7t8/images-3-removebg-preview.png'
        ]),
        CustomizationOption(name: 'Box Design 2', value: 'B002', imageUrls: [
          'https://i.ibb.co/GVC1Mqx/images-2-removebg-preview.png'
        ]),
        CustomizationOption(name: 'Box Design 3', value: 'B003', imageUrls: [
          'https://i.ibb.co/RgT040t/images-removebg-preview-1.png'
        ])
      ];
    } else if (optionType == 'Wrapping') {
      filteredOptions = [
        CustomizationOption(name: 'None', value: 'None', imageUrls: ['']),
        CustomizationOption(
            name: 'Wrapping Design 1',
            value: 'W001',
            imageUrls: [
              'https://i.ibb.co/55NqNq1/360-F-398328530-52-Lds-Nr-Qa-K6-Lntac64t-TQzoo-Sai7-Pqj-K-removebg-preview.png'
            ]),
        CustomizationOption(
            name: 'Wrapping Design 2',
            value: 'W002',
            imageUrls: [
              'https://i.ibb.co/k2CsmFw/images-1-removebg-preview.png'
            ]),
      ];
    } else {
      filteredOptions = [
        CustomizationOption(name: 'None', value: 'None', imageUrls: ['']),
        CustomizationOption(name: 'Ribbon Design 1', value: 'R001', imageUrls: [
          'https://i.ibb.co/JcFcGyD/free-grosgrain-ribbon-mockup-psd-template-removebg-preview.png'
        ]),
        CustomizationOption(name: 'Ribbon Design 2', value: 'R002', imageUrls: [
          'https://i.ibb.co/5kFf8cm/cfe670eec012b437c7025ed43c3b3fc8-removebg-preview.png'
        ]),
        CustomizationOption(name: 'Ribbon Design 3', value: 'R003', imageUrls: [
          'https://i.ibb.co/fCjdHKK/images-removebg-preview.png'
        ]),
      ];
    }
    return filteredOptions.map((option) {
      return DropdownMenuItem<String>(
        value: option.value,
        child: Row(
          children: [
            Text(option.name),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: option.imageUrls[0] != ""
                  ? Image.network(
                      option.imageUrls[0],
                      width: 40,
                      height: 70,
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF63131C),
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
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(widget.cartItems[index].productName),
                      subtitle: Text(
                          'Quantity: ${widget.cartItems[index].quantity} kgs'),
                    ),
                    BoxDropdown(
                        title: 'Box Design',
                        selectedValue: _selectedBoxDesigns[index],
                        items: _buildDropdownItems('Box'),
                        onChanged: (value) {
                          updateCustomizationOption(
                              widget.cartItems[index].productName,
                              'boxDesignID',
                              value!,
                              index);
                          setState(() {
                            _selectedBoxDesigns[index] = value;
                          });
                        }),
                    BoxDropdown(
                        title: 'Wrapping Design',
                        selectedValue: selectedWrappingDesign[index],
                        items: _buildDropdownItems('Wrapping'),
                        onChanged: (value) {
                          updateCustomizationOption(
                              widget.cartItems[index].productName,
                              'wrappingDesignID',
                              value!,
                              index);
                          setState(() {
                            selectedWrappingDesign[index] = value;
                          });
                        }),
                    BoxDropdown(
                        title: 'Ribbon Design',
                        selectedValue: selectedRibbonDesigns[index],
                        items: _buildDropdownItems('Ribbon'),
                        onChanged: (value) {
                          updateCustomizationOption(
                              widget.cartItems[index].productName,
                              'ribbonDesignID',
                              value!,
                              index);
                          setState(() {
                            selectedRibbonDesigns[index] = value;
                          });
                        }),
                    const Divider(),
                  ],
                );
              },
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                              cartItems: widget.cartItems,
                              totalAmount: _calculateTotal(widget.cartItems),
                              name: widget.name,
                              email: widget.email,
                              contact: widget.contact,
                              loggedIn: widget.email != null,
                              iscustomized: Provider.of<CartProvider>(context, listen: false).customizationOptions.isNotEmpty,
                            )));
                Provider.of<CartProvider>(context, listen: false)
                    .updateCustomize(true);
                Provider.of<CartProvider>(context, listen: false)
                    .updateCustomizationOptions(customizationOptions);
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Color(0xFF63131C),
              ),
              label: const Text(
                'Proceed with Customization',
                style: TextStyle(
                  color: Color(0xFF63131C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double _calculateTotal(List<Cart> items) {
  double total = 0;
  for (int i = 0; i < items.length; i++) {
    total += double.parse(items[i].price.replaceFirst("Rs.", "").trim());
  }
  return total;
}
