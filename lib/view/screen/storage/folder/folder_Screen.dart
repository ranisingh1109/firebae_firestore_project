import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebae_firestore_project/view/screen/storage/folder/pdf_screen.dart';
import 'package:firebae_firestore_project/view/screen/storage/folder/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'image_screen.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  var folders = <Map>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Folder Screen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewFolderDialog();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: getFolder(),
        builder: (context, snapshot) {
          var folders = snapshot.data?.docs;
          if (snapshot.hasData) {
            return folders!.isNotEmpty
                ? ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {

                      goToNextScreen(folders[index]["type"],);
                    },
                    leading: Icon(Icons.folder,color: Colors.yellowAccent,),
                    title: Text(folders[index]["name"],style: TextStyle(color: Colors.white),),
                    subtitle: Text(folders[index]["type"],style: TextStyle(color: Colors.white)),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: folders.length)
                : const Center(
              child: Text("No folder Found"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      backgroundColor: Colors.black,
    );

  }
  goToNextScreen(String type){
   if(type == folderType[0]){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageScreen(),));
   }
   else if(type == folderType[1]){
     Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen(),));
   } else{
     Navigator.push(context, MaterialPageRoute(builder: (context) => const PdfScreen(),));
   }
  }
  var folderType = ["Image", "Video", "Pdf"];
  TextEditingController folderNameController = TextEditingController();
  var selectType = "";

  createNewFolderDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Create new folder"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                items: folderType
                    .map((type) => DropdownMenuItem(
                  child: Text(type),
                  value: type,
                ))
                    .toList(),
                onChanged: (type) {
                  setState(() {
                    selectType = type ?? '';
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: folderNameController,
                decoration: InputDecoration(
                    hintText: "Enter your folder Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                addFolder();
                folderNameController.clear();
                selectType = '';
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },

    );

  }

  addFolder() async {
    await FirebaseFirestore.instance
        .collection("folders")
        .add({"name": folderNameController.text, "type": selectType}).then((value) {
      Fluttertoast.showToast(msg: "Created Folder");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFolder() {
    return FirebaseFirestore.instance.collection("folders").snapshots();
  }
}
