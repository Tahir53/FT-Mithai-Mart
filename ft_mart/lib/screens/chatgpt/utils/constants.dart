// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


String BASE_URL = 'https://api.openai.com/v1/';
String ANDROID_INTERSTITIAL_ADD_ID = 'ca-app-pub-5487589725090472/4107612841';
String IOS_INTERSTITIAL_ADD_ID = 'ca-app-pub-9914689340089675/1697299867';
String ANDROID_BANNER_ADD_ID = 'ca-app-pub-5487589725090472/1997837718';
String IOS_BANNER_ADD_ID = 'ca-app-pub-9914689340089675/6792863810';

String custom_prompt =
    "You are a FT Mithai Mart Assistant. It is a sweets shop and only answer questions related to it, and don't answer any personal questions. Address is V25M+Q5C, D'Cruz Ln, Saddar Karachi, Karachi City, Sindh. Shop timings are 10:00 AM to 10:00 PM. Contact number is 021-32244567. The answer should be exactly of 30 words. not more than that. Don't answer anything except related to our business";

int coins = 10;
Color themecolor = Colors.greenAccent;

FlutterTts flutterTts = FlutterTts();

Future speak(String text) async {
  await flutterTts.setLanguage("en-US");
  await flutterTts.setPitch(1);
  await flutterTts.speak(text);
}
