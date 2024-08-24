import 'package:firebae_firestore_project/view/screen/multi_colletion/list_of_chuldren_screen.dart';
import 'package:firebae_firestore_project/view/screen/multi_colletion/parent_screen.dart';
import 'package:flutter/material.dart';

import '../../../conttroller/multi_collection_firestore.dart';

class ListOfParentScreen extends StatefulWidget {
  const ListOfParentScreen({super.key,});

  @override
  State<ListOfParentScreen> createState() => _ListOfParentScreenState();
}

class _ListOfParentScreenState extends State<ListOfParentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Of Parent Screen"),
      ),
      body:
      StreamBuilder(
        stream: MultiCollectionFirestore().getFireStoreP(),
        builder: (context, snapshot) {
          var data = snapshot.data?.docs.toList();
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                var student = data[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListOfChildrenScreen(parentid: student.id,),
                        ));
                  },
                  child: Card(
                    child: Container(
                      child: Column(
                        children: [
                          Text("Name:-  ${student["name"]}"),
                          Text("Email:- ${student["email"]}"),
                          Text("Phone:- ${student["phone"]}"),
                          Text("Gender:- ${student["gender"]}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParentScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
