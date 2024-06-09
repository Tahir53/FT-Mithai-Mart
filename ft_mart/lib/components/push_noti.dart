import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() async {
    await _requestNotificationPermissions();

    _firebaseMessaging
        .subscribeToTopic('example'); // Example topic subscription

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the received message, e.g., show a notification
      // You can use a notification package like 'flutter_local_notifications'
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the resume of the app from the notification when the app is in the foreground
    });
  }

  Future<void> _requestNotificationPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
  }

  Future<void> _sendNotification(String token) async {
    // Add your logic to send a notification using the FCM token
    // This could involve calling a server API or using a cloud function
    // For simplicity, we'll just print a message here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Messaging Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String? token = await _firebaseMessaging.getToken();

            if (token != null) {
              await _sendNotification(token);
            }
          },
          child: const Text('Fetch FCM Token and Send Notification'),
        ),
      ),
    );
  }
}
