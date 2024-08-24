import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebae_firestore_project/view/screen/firebase_realtime_database/chating/chatScreen.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  TextEditingController nameController = TextEditingController();
  var deviceId = "";
  @override
  void initState() {
    getDataId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User  Details Screen"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Type your Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Device Id:- $deviceId"),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(name: nameController.text, deviceId: deviceId),));
          }, child: Text("Click"))
        ],
      ),
    );
  }

  Future<String?> getDataId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
       deviceId = androidDeviceInfo.id;
      setState(() {});

    }
    return null;
  }
}
