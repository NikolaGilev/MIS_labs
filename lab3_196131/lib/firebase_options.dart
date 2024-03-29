// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';

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
      print("started web...");
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
    apiKey: 'AIzaSyCtSnxVpeZpvUReIXRr3JcWIbl4rhrDGLw',
    appId: '1:744292444450:web:f0e5a1e17e0af65b2e9d7b',
    messagingSenderId: '744292444450',
    projectId: 'mis196131',
    authDomain: 'mis196131.firebaseapp.com',
    storageBucket: 'mis196131.appspot.com',
    measurementId: 'G-LWW0DFZT90',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCoe_VH_RXrriPI8xhe6aWCQN8Do7fSMAI',
    appId: '1:744292444450:android:e0899e625d29a3d22e9d7b',
    messagingSenderId: '744292444450',
    projectId: 'mis196131',
    storageBucket: 'mis196131.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsW5nhtduehEMvC4X8MtoLUzq7ZHsNl2I',
    appId: '1:744292444450:ios:993f13e2a847a1302e9d7b',
    messagingSenderId: '744292444450',
    projectId: 'mis196131',
    storageBucket: 'mis196131.appspot.com',
    iosBundleId: 'com.example.lab3196131',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDsW5nhtduehEMvC4X8MtoLUzq7ZHsNl2I',
    appId: '1:744292444450:ios:f2a3d814cbad06d42e9d7b',
    messagingSenderId: '744292444450',
    projectId: 'mis196131',
    storageBucket: 'mis196131.appspot.com',
    iosBundleId: 'com.example.lab3196131.RunnerTests',
  );


}

