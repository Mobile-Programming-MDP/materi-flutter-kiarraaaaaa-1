import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Platform tidak didukung');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBoiSlb3NpUUcSzmrTWGwjG0LMItL6v_1Y',
    appId: '1:263750555834:web:9692ed7b329b6306954a83',
    messagingSenderId: '263750555834',
    projectId: 'cepuapp-78c79',
    authDomain: 'cepuapp-78c79.firebaseapp.com',
    databaseURL: 'https://cepuapp-78c79-default-rtdb.firebaseio.com',
    storageBucket: 'cepuapp-78c79.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2mQfRq0wIoGn56tCbwB9CgNACUTHRh60',
    appId: '1:263750555834:android:d8995ed537c1dbab954a83',
    messagingSenderId: '263750555834',
    projectId: 'cepuapp-78c79',
    databaseURL: 'https://cepuapp-78c79-default-rtdb.firebaseio.com',
    storageBucket: 'cepuapp-78c79.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2mQfRq0wIoGn56tCbwB9CgNACUTHRh60',
    appId: '1:263750555834:ios:9692ed7b329b6306954a83',
    messagingSenderId: '263750555834',
    projectId: 'cepuapp-78c79',
    storageBucket: 'cepuapp-78c79.firebasestorage.app',
    iosBundleId: 'com.example.cepuApp',
  );
}
