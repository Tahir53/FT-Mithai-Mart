import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftmithaimart/screens/chatgpt/models/chat.dart';
import 'package:ftmithaimart/screens/chatgpt/models/model.dart';
import 'package:ftmithaimart/screens/chatgpt/network/api_services.dart';
import 'package:ftmithaimart/screens/chatgpt/utils/constants.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

final stt.SpeechToText _speech = stt.SpeechToText();

class ChatPage_ extends StatefulWidget {
  const ChatPage_({super.key});

  @override
  State<ChatPage_> createState() => _ChatPage_State();
}

class _ChatPage_State extends State<ChatPage_> {
  Color color = Colors.greenAccent;
  final dark = false;

  String messagePrompt = '';
  int tokenValue = 500;
  List<Chat> chatList = [];
  List<Chat> chatToStore = [];
  List<Model> modelsList = [];
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    getModels();
    // getData();
    //initPrefs();
  }

  void getModels() async {
    modelsList = await submitGetModelsForm(context: context);
  }

  List<DropdownMenuItem<String>> get models {
    List<DropdownMenuItem<String>> menuItems = List.generate(modelsList.length, (i) {
      return DropdownMenuItem(
        value: modelsList[i].id,
        child: Text(modelsList[i].id),
      );
    });
    return menuItems;
  }

  TextEditingController mesageController = TextEditingController();
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFFF8E6),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            pageHeader(),
            Expanded(child: _bodyChat(dark)),
            _formChat(dark),
          ],
        ),
      ),
    );
  }

  void saveData(int value) {
    prefs.setInt("token", value);
  }

  getData() async {
    prefs = await SharedPreferences.getInstance();
    String date = DateTime.now().toString().split(" ")[0];
    String oldChat = prefs.getString("date: $date") ?? '';
    print("OldChat: $oldChat");
    if (oldChat != '') {
      final List<dynamic> jsonList = json.decode(oldChat);
      chatToStore = jsonList.map((json) => Chat.fromJson(json)).toList();
      print("chatToStore: $chatToStore");
      setState(() {});
    }
    //return prefs.getInt("token") ?? 1;
  }

  _topChat() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset(
                    "assets/Color PNG.png",
                    height: 40,
                    color: Colors.white,
                  )),
              const Text(
                'Chat-Bot',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _bodyChat(bool dark) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: chatList.length,
      itemBuilder: (context, index) => _itemChat(
        chat: chatList[index].chat,
        message: chatList[index].msg,
        dark: dark,
      ),
    );
  }

  _itemChat({required int chat, required String message, required dark}) {
    return Row(
      mainAxisAlignment: chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            width: chat != 0 ? 300 : null,
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: chat == 0 ? const Color(0xffffC937) : const Color(0xff63131C),
              borderRadius: chat == 0
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
              border: chat != 0
                  ? Border.all(
                      width: 1,
                      color: const Color(0xff63131B),
                    )
                  : null,
            ),
            child: chatWidget(message, chat, dark),
          ),
        ),
      ],
    );
  }

  Widget chatWidget(String text, int chat, dark) {
    return IntrinsicWidth(
      child: SizedBox(
        // width: 250.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text.replaceFirst('\n\n', ''), style:  TextStyle(color: chat == 0 ? Colors.black : Colors.white,
                fontSize: 16,)),
            const SizedBox(
              height: 5,
            ),
            chat == 0
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Share.share(text);
                        },
                        child: const CircleAvatar(
                          radius: 15,
                          child: Icon(
                            Icons.share,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          // speak
                          speak(text);
                        },
                        child: const CircleAvatar(
                          radius: 15,
                          child: Icon(
                            Icons.volume_up,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: text)).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Text Copied"),
                              ),
                            );
                          });
                        },
                        child: const CircleAvatar(
                          radius: 15,
                          child: Icon(
                            Icons.copy,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  int count = 0;

  Widget _formChat(dark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: TextField(
                  onChanged: (data) {
                    // setState(() {});
                  },
                  controller: mesageController,
                  style: TextStyle(color: dark ? Colors.white : Colors.black),
                  cursorColor: const Color(0xff63131C),
                  decoration: InputDecoration(
                    hintText: 'Write To Send Message',
                    filled: true,
                    fillColor: dark ? Colors.black : const Color.fromARGB(255, 228, 224, 224),
                    hintStyle: TextStyle(color: dark ? Colors.white : Colors.black),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffffC937)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color:Color(0xff63131C)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelStyle: const TextStyle(fontSize: 12),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                    onTap: (() async {
                      isLoading = true;
                      messagePrompt = mesageController.text.toString();
                      setState(() {
                        chatList.add(Chat(msg: messagePrompt, chat: 0));
                        mesageController.clear();
                      });
                      // ignore: use_build_context_synchronously
                      submitGetChatsForm(
                        context: context,
                        prompt: count == 0
                            ? "say me Welcome message {hello , I am FT Mithai Mart Assistant. Ask me what you want to know? } "
                            : "$custom_prompt $messagePrompt",
                        tokenValue: tokenValue,
                      ).then((value) async {
                        count += 1;
                        isLoading = false;
                        chatList.addAll(value);
                        setState(() {});
                      });

                      setState(() {});
                    }),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff63131C),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.send_outlined,
                        color: Color(0xFFFFF8E6),
                        size: 18,
                      ),
                    ),
                  )
            ],
          ),
        ),

      ],
    );
  }

  Widget pageHeader(){
    return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: const Color(0xff801924),
                borderRadius: BorderRadius.circular(20)),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 10),
            height: 250,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_left,
                          color: Colors.white,
                          size: 45,
                        ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/Logo.png",
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Customer Service",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
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
                    const Text(
                      "Online",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
