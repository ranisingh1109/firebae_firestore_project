import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  File? selectedPdf;
  List<File> pdf = <File>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf Screen"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        takeMultiPdf();
      },child: Icon(Icons.add),),
      body: StreamBuilder(
        stream: getUploadedPdf(),
        builder: (context, snapshot) {
          var pdf = snapshot.data?.docs;
          if (pdf?.isNotEmpty == true) {
            return ListView.builder(itemCount: pdf?.length,
              itemBuilder: (context, index) {
                return showPdfView(pdf![index].data()["url"]);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  takeMultiPdf() async {
    FilePickerResult? pikerPdf = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['PDF', 'Video', 'png'],
    );
    if (pikerPdf != null) {
      var file = pikerPdf.files.map((path) => File(path.path!)).toList();
      for (var multiPdf in file) {
        uploadPdf(multiPdf);
        print(multiPdf.path);
      }
      // setState(() {
      //   image.addAll(file);
      // });
      print(file.first.path);
    } else {}
  }
  uploadPdf(File file) {
    var storage = FirebaseStorage.instance;
    storage
        .ref("PDF-IMAGE")
        .child(file.path.split("/").last)
        .putFile(File(file.path))
        .then((value) async {
      var pdfUrl = await value.ref.getDownloadURL();
      print(pdfUrl);
      FirebaseFirestore.instance.collection("pdf").add({"url": pdfUrl});
      Fluttertoast.showToast(msg: "Pdf uploaded");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUploadedPdf() {
    var instance = FirebaseFirestore.instance.collection("pdf");
    return instance.snapshots();
  }

  showPdfView(String pdfpath) {
    return SizedBox(
      height: 400,
      child: SfPdfViewer.network(pdfpath),
    );
  }
}
