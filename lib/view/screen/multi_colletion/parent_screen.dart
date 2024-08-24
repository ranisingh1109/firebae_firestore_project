import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebae_firestore_project/view/screen/multi_colletion/list_of_parent_screen.dart';
import 'package:flutter/material.dart';

import '../../../conttroller/multi_collection_firestore.dart';

class ParentScreen extends StatefulWidget {

  ParentScreen({super.key,});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: Column(
        children: [
          // ElevatedButton(onPressed: ()async{
          //   var firestore =   FirebaseFirestore.instance;
          //   var doc = await  firestore.collection("parent").add({
          //        "name":"Surender Mahto",
          //        "email":"@SurenderM",
          //         "phone":"9430223280"
          //   });
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => childrenScreen(id: doc.id.toString(),),));
          // }, child: const Text("Add Data"))
          Padding(padding: const EdgeInsets.all(7),
            child: TextFormField(controller: nameController,
              decoration: InputDecoration(hintText: "Enter your Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),),),
          Padding(padding: const EdgeInsets.all(7),
            child: TextFormField(controller: emailController,
              decoration: InputDecoration(hintText: "Enter your Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),),),
          Padding(padding: const EdgeInsets.all(7),
            child: TextFormField(controller: phoneController,
              decoration: InputDecoration(hintText: "Enter your Phone",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),),),
          Padding(padding: const EdgeInsets.all(7),
            child: TextFormField(controller: genderController,
              decoration: InputDecoration(hintText: "Enter your Gender",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),),),
          ElevatedButton(onPressed: () {
            MultiCollectionFirestore().firebaseFireStoreP(
                nameController.text, emailController.text, phoneController.text,
                genderController.text);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ListOfParentScreen(),));
          }, child: const Text("Add Parent"))
        ],
      ),);
  }
}