import 'package:firebae_firestore_project/conttroller/firebase_firestore_crud.dart';
import 'package:firebae_firestore_project/view/screen/crud/update_student_screen.dart';
import 'package:flutter/material.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  //TextEditingController ageController = TextEditingController();

  TextEditingController villageController = TextEditingController();
  TextEditingController pin_codeController = TextEditingController();
  TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FIREBASE FIRESTORE SCREEN"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: emailController,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(7),
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //         hintText: "Enter your Phone",
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10))),
            //     controller: phoneController,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Gender",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: genderController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Village",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: villageController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Pin code",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: pin_codeController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Post",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: postController,
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(7),
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //         hintText: "Enter your Age",
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10))),
            //     controller: ageController,
            //   ),
            // ),
            ElevatedButton(
                onPressed: () {
                  FirebaseFirestoreData()
                      .addStudentData(
                          nameController.text,
                          emailController.text,
                          // phoneController.text,
                          genderController.text,
                          //ageController.text
                          villageController.text,
                          int.parse(pin_codeController.text),
                          postController.text)
                      .then((_) {
                    // setState(() {
                    //   FirebaseFirestoreData().getStudentsData();
                    // });
                  });
                },
                child: Text("Add Student")),
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestoreData().getStudentsData(),
                    builder: (context, snapshot) {
                      var data = snapshot.data?.docs.toList();
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            var student = data[index];
                            return Card(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(" Name:-  ${student['name']}"),
                                        Text(" Email:-  ${student['email']}"),
                                        //  Text(" Phone:-  ${student['phone']}"),
                                        Text(" Gender:-  ${student['gender']}"),
                                        //    Text(" Age:-  ${student['age']}"),
                                        Text(
                                            " Village:-  ${student['address']['village']}"),
                                        Text(
                                            " Pin_Code:-  ${student['address']['pin_code']}"),
                                        Text(
                                            " Post:-  ${student['address']['post']}"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 40),
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            UpdateStudentScreen(
                                                                id: data[index]
                                                                    .id, name: data[index].data()['name'], email: data[index].data()['email'], gender: data[index].data()['gender'],)));
                                                // showMyButtomSheet(
                                                //     data[index].id);
                                              },
                                              icon: Icon(Icons.edit)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: IconButton(
                                              onPressed: () {

                                              },
                                              icon: Icon(Icons.delete)),
                                        ),
                                      ],
                                    )
                                  ]),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }))
          ],
        ),
      ),
    );
  }

  showMyButtomSheet(String docId) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController genderController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
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
                    hintText: "Enter your Phone",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: phoneController,
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Enter your Age",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                controller: ageController,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> updatedData = {
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'gender': genderController.text,
                    'age': ageController.text,
                  };
                  FirebaseFirestoreData().upStudentData(docId, updatedData);
                  Navigator.of(context).pop();
                  // setState(() {
                  //   FirebaseFirestoreData().getStudentsData();
                  // });
                },
                child: Text(" UPDATA"))
          ],
        );
      },
    );
  }
}
