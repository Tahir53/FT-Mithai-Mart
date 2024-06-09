import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC14xDKe6bBVjzL9KcBO7p9MNHxtEXlAF8',
    appId: '1:722881978336:web:11a6fe61dcf31a8ac45585',
    messagingSenderId: '722881978336',
    projectId: 'ftmithaimart-4e059',
    authDomain: 'ftmithaimart-4e059.firebaseapp.com',
    storageBucket: 'ftmithaimart-4e059.appspot.com',
    measurementId: 'G-N8S9HX6X7D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBRPwp0O-kxX5wN5di787nUk5CNOdVcsH8',
    appId: '1:722881978336:android:21e1bb38e3f2ab28c45585',
    messagingSenderId: '722881978336',
    projectId: 'ftmithaimart-4e059',
    storageBucket: 'ftmithaimart-4e059.appspot.com',
  );
}
