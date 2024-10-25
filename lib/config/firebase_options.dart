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
    apiKey: 'AIzaSyC-Al6k_Z1CdZjZe35Y5zQu1Tczs_RYknQ',
    appId: '1:715680838573:web:c75655c42964471ca0e724',
    messagingSenderId: '715680838573',
    projectId: 'socialmediaapp-dcd9e',
    authDomain: 'socialmediaapp-dcd9e.firebaseapp.com',
    storageBucket: 'socialmediaapp-dcd9e.appspot.com',
    measurementId: 'G-5ZRN7MCK6V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4diEv9Irh0QhkPC0KRwy5oQB1DR-f7kM',
    appId: '1:715680838573:android:bc67573d33b3568ea0e724',
    messagingSenderId: '715680838573',
    projectId: 'socialmediaapp-dcd9e',
    storageBucket: 'socialmediaapp-dcd9e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGUrImapnjAsVlUX3izCwvHGO9k31fpbk',
    appId: '1:715680838573:ios:617ffa49fa6d7d69a0e724',
    messagingSenderId: '715680838573',
    projectId: 'socialmediaapp-dcd9e',
    storageBucket: 'socialmediaapp-dcd9e.appspot.com',
    iosBundleId: 'com.example.socialMediaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGUrImapnjAsVlUX3izCwvHGO9k31fpbk',
    appId: '1:715680838573:ios:617ffa49fa6d7d69a0e724',
    messagingSenderId: '715680838573',
    projectId: 'socialmediaapp-dcd9e',
    storageBucket: 'socialmediaapp-dcd9e.appspot.com',
    iosBundleId: 'com.example.socialMediaApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC-Al6k_Z1CdZjZe35Y5zQu1Tczs_RYknQ',
    appId: '1:715680838573:web:12d7eb3742f8b2bda0e724',
    messagingSenderId: '715680838573',
    projectId: 'socialmediaapp-dcd9e',
    authDomain: 'socialmediaapp-dcd9e.firebaseapp.com',
    storageBucket: 'socialmediaapp-dcd9e.appspot.com',
    measurementId: 'G-06WEJWN844',
  );
}
