// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return ios;
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
    apiKey: 'AIzaSyA-Rj8Lr2nhlZxrDcMP0FfxhmP4wO-9Ctw',
    appId: '1:987540147963:web:f5ccf158b645241ad0ea5e',
    messagingSenderId: '987540147963',
    projectId: 'health-pal-4f02d',
    authDomain: 'health-pal-4f02d.firebaseapp.com',
    databaseURL: 'https://health-pal-4f02d-default-rtdb.firebaseio.com',
    storageBucket: 'health-pal-4f02d.firebasestorage.app',
    measurementId: 'G-4EB8VCV1KB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLN5v_4GLFWX0ubVwX1AQhOD2DEKkQB6I',
    appId: '1:987540147963:android:d9ee50113e0e5453d0ea5e',
    messagingSenderId: '987540147963',
    projectId: 'health-pal-4f02d',
    databaseURL: 'https://health-pal-4f02d-default-rtdb.firebaseio.com',
    storageBucket: 'health-pal-4f02d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKPvZjgW3MRDYD14xf21eyQwlRyUbWyrg',
    appId: '1:987540147963:ios:0b0dd0f0d36f09a5d0ea5e',
    messagingSenderId: '987540147963',
    projectId: 'health-pal-4f02d',
    databaseURL: 'https://health-pal-4f02d-default-rtdb.firebaseio.com',
    storageBucket: 'health-pal-4f02d.firebasestorage.app',
    iosBundleId: 'com.example.healthPal',
  );
}
