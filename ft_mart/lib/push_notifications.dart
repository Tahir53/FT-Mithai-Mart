import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dbHelper/mongodb.dart';
import 'main.dart';
import 'model/orders_model.dart';
import 'package:http/http.dart' as http;

class PushNotifications {

  static final String serverKey = 'AAAAqE8fn-A:APA91bGiNXM_cOPad95u-e78Af6alBfTUouU1Enc6gP8ydNX6tg9kQ0CcA4I_Xds-0CON7RQbMCuLVdvTHs0g3rp1KPBXrPvoEbBEBcaz7MGqcp1l8u2NW9Yik0c6q8UoJc2dcCq7Z2Z';
  static final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // get the device fcm token
    final token = await _firebaseMessaging.getToken();
    print("device token: $token");
    return token;
  }

  static returnToken() async {
    return await _firebaseMessaging.getToken();
  
  }

  static Future<void> sendNotification(String orderId, String deviceToken, String title, String body) async {
    final Map<String, dynamic> notification = {
      'title': title,
      'body': body,
      'priority': 'high',
    };

    final Map<String, dynamic> data = {
      'orderId': orderId,
    };

    final Map<String, dynamic> requestBody = {
      'notification': notification,
      'data': data,
      'to': deviceToken,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully to device token $deviceToken');
    } else {
      print('Failed to send notification: ${response.statusCode}');
    }
  }


  static Future<void> sendComplaintNotification(String complaintId, String deviceToken, String title, String body) async {
    final Map<String, dynamic> notification = {
      'title': title,
      'body': body,
      'priority': 'high',
    };

    final Map<String, dynamic> data = {
      'complaintId': complaintId,
    };

    final Map<String, dynamic> requestBody = {
      'notification': notification,
      'data': data,
      'to': deviceToken,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully to device token $deviceToken');
    } else {
      print('Failed to send notification: ${response.statusCode}');
    }
  }


//initalize local notifications
  static Future localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed("/order_tracking", arguments: notificationResponse);
  }



  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
