import 'package:flutter/material.dart';

import '../../../conttroller/multi_collection_firestore.dart';

class ChildrenScreen extends StatefulWidget {
  final String parentId;

  const ChildrenScreen({super.key, required this.parentId,});

  @override
  State<ChildrenScreen> createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        children: [
          // ElevatedButton(onPressed: ()async{
          //   var firestore =   FirebaseFirestore.instance;
          //   await  firestore.collection("children").add({
          //     "name":"rani kumari",
          //     "email":"ranik@gmail.com",
          //       "child_Id":  widget.id
          //   });
          // }, child: const Text("Add children"))
          Padding(
            padding: const EdgeInsets.all(7),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Enter your Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Enter your Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7),
            child: TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                  hintText: "Enter your Phone",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7),
            child: TextFormField(
              controller: genderController,
              decoration: InputDecoration(
                  hintText: "Enter your Gender",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                MultiCollectionFirestore().firebaseFireStoreChild(
                    emailController.text,
                    emailController.text,
                    phoneController.text,
                    genderController.text,
                    widget.parentId);
                  Navigator.pop(context);
              },
              child: const Text("Add Children"))
        ],
      ),
    );
  }
  }

