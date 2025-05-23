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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAqq7i7VJGa0Vv1HIJ2ule-yI62CljdqfU',
    appId: '1:688114393749:web:01f2b7af29379ad4f8f19c',
    messagingSenderId: '688114393749',
    projectId: 'travel-eb4c8',
    authDomain: 'travel-eb4c8.firebaseapp.com',
    storageBucket: 'travel-eb4c8.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDp2q41Ltmjoek0Ekj9aj9YyNyPIXxcYLE',
    appId: '1:688114393749:android:1304144af13648f4f8f19c',
    messagingSenderId: '688114393749',
    projectId: 'travel-eb4c8',
    storageBucket: 'travel-eb4c8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4eJ_vP63vHJ32xSvAIzniJPerMYjqwCg',
    appId: '1:688114393749:ios:473ccad9de07ce06f8f19c',
    messagingSenderId: '688114393749',
    projectId: 'travel-eb4c8',
    storageBucket: 'travel-eb4c8.firebasestorage.app',
    iosBundleId: 'com.example.travel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4eJ_vP63vHJ32xSvAIzniJPerMYjqwCg',
    appId: '1:688114393749:ios:473ccad9de07ce06f8f19c',
    messagingSenderId: '688114393749',
    projectId: 'travel-eb4c8',
    storageBucket: 'travel-eb4c8.firebasestorage.app',
    iosBundleId: 'com.example.travel',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAqq7i7VJGa0Vv1HIJ2ule-yI62CljdqfU',
    appId: '1:688114393749:web:45da1e28bbdc62dcf8f19c',
    messagingSenderId: '688114393749',
    projectId: 'travel-eb4c8',
    authDomain: 'travel-eb4c8.firebaseapp.com',
    storageBucket: 'travel-eb4c8.firebasestorage.app',
  );
}
