import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  // create an instance of Firebase Messaging
  static final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  static Future<void> initializeNotifications(Function callback) async {
    // request permission to send notifications
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      callback();
    });
  }

  // function to request token
  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
