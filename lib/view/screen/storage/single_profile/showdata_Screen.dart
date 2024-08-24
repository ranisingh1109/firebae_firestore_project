import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ShowDataScreen extends StatefulWidget {
  const ShowDataScreen({super.key});

  @override
  State<ShowDataScreen> createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Data Screen"),
      ),
      body: FutureBuilder(
        future: getProfileDta(),
        builder: (context, snapshot) {
          var data = snapshot.data?.docs;
          var singleData = data![0].data();
          return SingleChildScrollView(
            child: Card(
              child: Column(
                children: [
                       Text("Name:-   ${singleData["name"]}"),
                       Text("Email:-  ${singleData["email"]}"),
                       Text("Phone:-   ${singleData["phone"]}"),
                       Text("ImageUrl:-   ${singleData["image"]}"),
              
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getProfileDta() async {
    var firebase = FirebaseFirestore.instance;
  return await firebase.collection("proFile").get();

  }
}
