import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UpdataScreen extends StatefulWidget {
  const UpdataScreen({super.key});

  @override
  State<UpdataScreen> createState() => _UpdataScreenState();
}

class _UpdataScreenState extends State<UpdataScreen> {
   File? selectedImage;
   List<File> image = <File>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Updata Screen"),),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            takeMultiImage();
          }, child: Text("Take File"))
        ],
      ),
    );
  }
  takeMultiImage() async {
    FilePickerResult? pikerImage =
    await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pikerImage != null) {
      var file = pikerImage.paths.map((path) => File(path!)).toList();
      setState(() {
        image.addAll(file);
      });
      for (var multiImage in file) {
        uploadImage(multiImage);
      }
    } else {}
  }

  uploadImage(File file) {
    var storage = FirebaseStorage.instance;
    storage
        .ref("PROFILE-IMAGE")
        .child(file.path.split("/").last)
        .putFile(File(file.path))
        .then((value) async {
      var imageUrl = await value.ref.getDownloadURL();
      print(imageUrl);
    });
  }
}
