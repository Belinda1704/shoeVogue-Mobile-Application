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
    apiKey: 'AIzaSyB5yYRvgByJj1uF3QAjfoDocaehtRupl9I',
    appId: '1:872644437819:web:977f6b76a8fb891d8cb91e',
    messagingSenderId: '872644437819',
    projectId: 'shoevogueapp',
    authDomain: 'shoevogueapp.firebaseapp.com',
    storageBucket: 'shoevogueapp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4ZD8ImklUC4ybVw-Edp4aFziOxjyuiMY',
    appId: '1:872644437819:android:8dee49d2e3c8fafd8cb91e',
    messagingSenderId: '872644437819',
    projectId: 'shoevogueapp',
    storageBucket: 'shoevogueapp.firebasestorage.app',
    androidClientId: '872644437819-umdtjt0jshehcch0ls4j271d48j6s0h3.apps.googleusercontent.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYOgkRCfpfrhDUlobRNUy53Ri8uq95WIk',
    appId: '1:872644437819:ios:6885eedf60ca4a978cb91e',
    messagingSenderId: '872644437819',
    projectId: 'shoevogueapp',
    storageBucket: 'shoevogueapp.firebasestorage.app',
    iosClientId: '872644437819-el33l1spk4smsditl4blja0fmu83qsij.apps.googleusercontent.com',
    iosBundleId: 'com.shoevogue.app',
  );

}