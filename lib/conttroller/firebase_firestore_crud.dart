import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseFirestoreData {
  // var firebase = Firebase
  var collectionName = "Student";
  var firebase = FirebaseFirestore.instance;

  addStudentData(
      String name,
      String email,
      String gender,
      String village,
      int pin_code,
      String post) async {
    // var a = FirebaseFirestore.instance;
    await firebase
        .collection(collectionName)
        .add(({
          "name": name,
          "email": email,
         // "phone": phone,
          "gender": gender,
        //  "age": age,
          "address": {"village": village, "pin_code": pin_code, "post": post}}),)
        .then((refe) {
      Fluttertoast.showToast(msg: "Document${refe.id}");
      print("Document${refe.id}");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "${error}");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentsData() {
    var firestore = FirebaseFirestore.instance;
    var students = firestore.collection(collectionName);
    var data = students.snapshots();
    return data;
  }
  // Future<List<Map<String, dynamic>>> getStudentData() async {
  //   QuerySnapshot student = await firebase.collection("Student").get();
  //   return student.docs
  //       .map((doc) => doc.data() as Map<String, dynamic>)
  //       .toList();
  // }
  Future<void> upStudentData(String docId, Map<String, dynamic> upData) async {
    await firebase.collection(collectionName).doc(docId).update(upData);
  }

  Future<void> deleteStudentData(
    String docId,
  ) async {
    await firebase.collection(collectionName).doc(docId).delete();
  }
}
