import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/message_text_field.dart';
import 'package:ftmithaimart/components/reciever_message_container.dart';
import 'package:ftmithaimart/components/search_data_tile.dart';
import 'package:ftmithaimart/components/sender_message_container.dart';
import 'package:ftmithaimart/model/cart_model.dart';
import 'package:ftmithaimart/model/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();

  List<String> senderMessages = [];
  List<String> recieverMessages = [];




  sendMessagetoAPI(String message) async {
    print("send message function called");
    print(message);
    final apiUrl = Uri.parse(
        "https://rldd7tf8-5000.asse.devtunnels.ms/query?prompt=$message");

    try {
      final response = await http.get(apiUrl, headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        final res = response.body;
        print("response: $res");
        setState(() {
          senderMessages.add(res);
          recieverMessages.add("Response");
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    void updateCart(String product, String price, double quantity) {
      print("updatecart");
      Provider.of<CartProvider>(context, listen: false).addToCart(
          Cart(productName: product, price: price, quantity: quantity));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E6),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xff801924),
                borderRadius: BorderRadius.circular(20)),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 50),
            height: 350,
            // color: const Color(0xFFFFF8E6),

            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_left,
                          color: Colors.white,
                          size: 45,
                        ))),
                Image.asset(
                  "assets/Logo.png",
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Customer Service",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Have any questions?",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 11,
                      height: 11,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFF6FE170)),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Online",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: senderMessages.length,
                itemBuilder: (context, index) {
                  if (index == 2) {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Recommended Products",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              )),
                        ),
                        SearchDataField(
                            name: "Gulab Jaman",
                            category: "Classic Sweets",
                            price: "1200",
                            image:
                                "https://i.postimg.cc/zXKhGcGw/Gulaab-Jaman.jpg",
                            stock: 44,
                            description:
                                "Indulge in the sweet nostalgia of our traditional recipe for “Gulaab Jamun”, these golden brown dumplings are made up of pure khoya, fried to perfection and lovingly dipped in fragrant sugar syrup.",
                            discount: 0,
                            onPopupMenuButtonPressed: updateCart),
                      ],
                    );
                  }
                  if (index % 2 == 0) {
                    return SenderMessageContainer(
                      message: senderMessages[index],
                      timestamp: "0:300",
                    );
                  } else {
                    return ReceiverMessageContainer(
                      message: "hello",
                      timestamp: "3:00",
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                MessageTextField(controller: messageController),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await sendMessagetoAPI(messageController.text);
                    // setState(() {
                    //   senderMessages.add(messageController.text);
                    // });
                    messageController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF63131C),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.085,
                    height: MediaQuery.of(context).size.height * 0.049,
                    alignment: Alignment.center,
                    child: Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}