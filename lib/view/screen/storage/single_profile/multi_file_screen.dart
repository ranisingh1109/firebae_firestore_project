import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MultiFileScreen extends StatefulWidget {
  const MultiFileScreen({super.key});

  @override
  State<MultiFileScreen> createState() => _MultiFileScreenState();
}
class _MultiFileScreenState extends State<MultiFileScreen> {
  File? selectedImage;
  List<File> image = <File>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Multi File Screen "),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              color: Colors.cyan,
              height: 200,
              width: 200,
              child: selectedImage != null
                  ? Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image, size: 100, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  takeSingleImage();
                },
                child: const Text("Single Image")),
            SizedBox(height: 20),
            Expanded(
              child:
              ListView.builder(
                itemCount: image.length,
                itemBuilder: (context, index) {
                  return Container(
                      height: 800,
                      width: 100,
                      color: Colors.blue,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisSpacing: 20),
                        itemCount: image.length,
                        itemBuilder: (context, index) {
                          return Image.file(
                            image[index],
                            fit: BoxFit.contain,
                          );
                        },
                      )
                      //
                      );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  takeMultiImage();
                },
                child: const Text("Multipart Image")),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  uploadAllImage();
                },
                child: const Text("Upload All Image"))
          ],
        ),
      ),
    );
  }
  takeSingleImage() async {
    FilePickerResult? pikerImage = await FilePicker.platform.pickFiles();
    if (pikerImage != null) {
      File file = File(pikerImage.files.single.path!);
      setState(() {
        selectedImage = file;
      });
    } else {}
  }
  takeMultiImage() async {
    FilePickerResult? pikerImage =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pikerImage != null) {
      var file = pikerImage.paths.map((path) => File(path!)).toList();
      setState(() {
        image.addAll(file);
      });
      for (var multiImage in file) {}
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
  uploadAllImage() async {
    if (selectedImage != null) {
      await uploadImage(selectedImage!);
    }
    for (var files in image) {
      uploadImage(files);
    }
    Fluttertoast.showToast(msg: "IMAGE UPLOAD");
  }
}
