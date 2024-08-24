import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),
      body:
      SingleChildScrollView(
        child:
        Column(
          children: [
            imageFile == null
                ? ClipRRect(
                    child: Container(
                      height: 110,
                      width: 110,
                      color: Colors.black,
                    ),)
                : Image.file(File(imageFile?.path ?? "")),
            Padding(
              padding: const EdgeInsets.all(7),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Enter your Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "Enter your Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                    hintText: "Enter your Phone",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  takeImage();
                },
                child: Text("Click Image")),
            ElevatedButton(
                onPressed: () {
                  uploadImage();
                },
                child: const Text("uploadImage")),
          ],
        ),
      ),
    );
  }

  takeImage() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = image! as XFile?;
    });
  }

  uploadImage() {
    var storage = FirebaseStorage.instance;
    storage
        .ref("ProfileImage")
        .child(imageFile?.name ?? "")
        .putFile(File(imageFile?.path ?? ""))
        .then((value) async {
      var imageUrl = await value.ref.getDownloadURL();
      print(imageUrl);
      await FirebaseFirestore.instance.collection("proFile").add({
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "image": imageUrl
      });
      Fluttertoast.showToast(msg: "IMAGE UPLOAD");
    });
  }
}
