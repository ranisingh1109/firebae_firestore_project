import 'package:flutter/material.dart';

import '../../../conttroller/multi_collection_firestore.dart';
import 'children_Screen.dart';

class ListOfChildrenScreen extends StatefulWidget {
  final String parentid;

  const ListOfChildrenScreen({super.key, required this.parentid});

  @override
  State<ListOfChildrenScreen> createState() => _ListOfChildrenScreenState();
}

class _ListOfChildrenScreenState extends State<ListOfChildrenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Of Children Screen"),
      ),
      body: StreamBuilder(
        stream: MultiCollectionFirestore().getFireStoreChild(widget.parentid),
        builder: (context, snapshot) {
          var data = snapshot.data?.docs.toList();
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                var student = data[index];
                return Card(
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
                builder: (context) => ChildrenScreen(
                  parentId: widget.parentid,
                ),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
