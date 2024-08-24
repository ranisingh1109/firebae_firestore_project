import 'package:flutter/material.dart';

import '../../../conttroller/firebase_firestore_crud.dart';

class UpdateStudentScreen extends StatefulWidget {
  final String id;
  final String name;
  final String email;
  final String gender;
  const UpdateStudentScreen({super.key, required this.id, required this.name, required this.email, required this.gender});

  @override
  State<UpdateStudentScreen> createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
     nameController = TextEditingController(text: widget.name);
     emailController = TextEditingController(text: widget.email);
     genderController = TextEditingController(text: widget.gender);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Gender",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: genderController,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> updatedData = {
                    'name': nameController.text,
                    'email': emailController.text,
                    'gender': genderController.text,
                  };
                  FirebaseFirestoreData().upStudentData(widget.id, updatedData);
                  Navigator.of(context).pop();
                  // setState(() {
                  //   FirebaseFirestoreData().getStudentsData();
                  // });
                },
                child: Text(" UPDATA"))
          ],
        ),
      ),
    );
  }
}
