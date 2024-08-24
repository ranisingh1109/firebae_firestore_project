import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationServics{
  getFCMToken() async {
   var token = await FirebaseMessaging.instance.getToken();
    print("FCMToken: $token");
  }
  getForgroundNotification(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message)async{
      print(message.notification?.title);
      print(message.notification?.body);
       if(await requestNotificationPermissions() == true){
         initializeNotifications();
       }
    });

  }

  initializeNotifications() async {
    // object of FlutterLocalNotificationPlugin
    FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
    // android platform initialization settings
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    // init notification plugin
    await notificationsPlugin.initialize(InitializationSettings(
      // setting for android
        android: androidInitializationSettings));
    // show notification
    notificationsPlugin.show(1, "Hii", "Rani, How aur you?", const NotificationDetails(android: AndroidNotificationDetails("channelId", "channelName")));
  }

  Future<bool> requestNotificationPermissions() async {
    var value = false;
    final PermissionStatus status = await Permission.notification.request();
     if (status.isDenied) {
      // Notification permissions denied
      //  exit(0);
       await Permission.notification.request();
       value = false;
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      await openAppSettings();
      value = true;
    }

     return value;
  }
}