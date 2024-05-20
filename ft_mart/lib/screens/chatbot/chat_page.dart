import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/message_text_field.dart';
import 'package:ftmithaimart/components/reciever_message_container.dart';
import 'package:ftmithaimart/components/sender_message_container.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();

  List<Map<String, String>> messages = [];




  sendMessagetoAPI(String message) async {
    print("send message function called");
    print("Message send to API: $message");
    final apiUrl = Uri.parse(
        "https://b1c7-2400-adc1-11d-a700-ad98-c596-a4a6-352.ngrok-free.app/query?prompt=$message");

    try {
      final response = await http.get(apiUrl, headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        final res = response.body;
        print("response: $res");

          var messageMap = {"sender" : message, "reciever" : res};
          messages.add(messageMap);
          print(messages);

          setState(() {
            
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
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SenderMessageContainer(message: messages[index]["sender"]!, timestamp: "00:00"),
                      const SizedBox(height: 10,),
                      ReceiverMessageContainer(message: messages[index]["reciever"]!, timestamp: "00:00")
                    ],
                  );
                
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