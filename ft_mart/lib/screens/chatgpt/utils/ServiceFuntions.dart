import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../errors/exceptions.dart';
import '../models/chat.dart';
import '../network/error_message.dart';
import '../network/network_client.dart';
import 'constants.dart';

void copyToClipboard(
  context,
  String text,
) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Copied to clipboard'),
    ),
  );
}

void shareTweetIdeas(String text) {
  Share.share(text);
}

Future<List<Chat>> submitGetChatsForm({
  required BuildContext context,
  required String prompt,
  required int tokenValue,
  String? model,
  String? outputLanguageCode,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Chat> chatList = [];
  final prefs = await SharedPreferences.getInstance();

  try {
    final res = await networkClient.post(
      "${BASE_URL}completions",
      {
        "model": model ?? "text-davinci-003",
        "prompt": prompt,
        "temperature": 0,
        "max_tokens": tokenValue,
      },
      token: OPEN_API_KEY,
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp['choices'] != null && mp['choices'].length > 0) {
      chatList = List.generate(mp['choices'].length, (i) {
        return Chat.fromJson(<String, dynamic>{
          'msg': mp['choices'][i]['text'],
          'chat': 1,
        });
      });
      debugPrint(chatList.toString());
    }
    coins--;
    await prefs.setInt("coins", coins);
  } on RemoteException catch (e) {
    Logger().e(e.dioError);
    errorMessage(context, e.dioError);
  }

  return chatList;
}

// Future<List<Chat>> submitGetChatsForm2({
//   required BuildContext context,
//   required String prompt,
//   required int tokenValue,
//   String? model,
//   String? outputLanguageCode,
//   required Function(int) updateCoins,
// }) async {
//   //
//   NetworkClient networkClient = NetworkClient();
//   List<Chat> chatList = [];
//   final prefs = await SharedPreferences.getInstance();
//   if (coins - 1 >= 0) {
//     try {
//       final res = await networkClient.post(
//         "${BASE_URL}completions",
//         {
//           "model": model ?? "text-davinci-003",
//           "prompt": prompt,
//           "temperature": 0,
//           "max_tokens": tokenValue,
//         },
//         token: OPEN_API_KEY,
//       );
//       Map<String, dynamic> mp = jsonDecode(res.toString());
//       debugPrint(mp.toString());
//       if (mp['choices'] != null && mp['choices'].length > 0) {
//         chatList = List.generate(mp['choices'].length, (i) {
//           return Chat.fromJson(<String, dynamic>{
//             'msg': mp['choices'][i]['text'],
//             'chat': 1,
//           });
//         });
//         debugPrint(chatList.toString());
//       }
//       updateCoins(coins - 1); // call the update function
//       await prefs.setInt("coins", coins);
//     } on RemoteException catch (e) {
//       Logger().e(e.dioError);
//       errorMessage(context, e.dioError);
//     }
//   } else {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (ctx) => const Subscritionpage(),
//       ),
//     );
//   }
//   return chatList;
// }

class OutputCard extends StatefulWidget {
  const OutputCard({
    Key? key,
    required this.tweetIdeas,
  }) : super(key: key);

  final List<String> tweetIdeas;

  @override
  _OutputCardState createState() => _OutputCardState();
}

class _OutputCardState extends State<OutputCard> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ScaleTransition(
        scale: _animation,
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.check_circle_rounded,
                      color: widget.tweetIdeas.isNotEmpty ? Colors.green : Colors.grey,
                    ),
                    title: const Text(
                      "Result",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: const Text(
                      "Please see the below result",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.tweetIdeas.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: themecolor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.tweetIdeas.map((tweet) => Column(
                                    children: [
                                      Text(
                                        "- $tweet",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                          fontFamily: 'Helvetica Neue',
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Divider(
                                        color: themecolor,
                                      ),
                                      CopyandShare(tweet: tweet),
                                      const SizedBox(height: 12),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CopyandShare extends StatelessWidget {
  const CopyandShare({
    super.key,
    required this.tweet,
  });

  final String tweet;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            copyToClipboard(context, tweet);
          },
          icon: Icon(
            Icons.copy,
            color: themecolor,
          ),
        ),
        IconButton(
          onPressed: () {
            Share.share(tweet);
          },
          icon: Icon(
            Icons.share,
            color: themecolor,
          ),
        ),
      ],
    );
  }
}

updateCoinCount(int count) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt("coins", count);
}
