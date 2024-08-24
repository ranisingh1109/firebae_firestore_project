import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseFirestoreAuthentication {
  final FirebaseAuth loginAuthentication = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  loginData(String email, String password) async {
    var firebaseAuth = FirebaseFirestore.instance;
    var firestore = await firebaseAuth
        .collection("User")
        .where("email", isEqualTo: email)
        .get();
    if (firestore.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: "Email already  exist");
    } else {
      await firebaseAuth
          .collection("User")
          .add({"email": email, "password": password});
    }
  }

  register(String email, String password) async {
    var firebaseAuth = FirebaseFirestore.instance;
    var exist = await firebaseAuth
        .collection("User")
        .where("email", isEqualTo: email)
        .get();
    if (exist.docs.isNotEmpty) {
      var user = await exist.docs
          .firstWhere((User) => User.data()["password"] == password)
          .exists;
      if (user) {
        Fluttertoast.showToast(msg: "Login Successful");
      } else {
        Fluttertoast.showToast(msg: "Please  register ");
      }
    }else {
      Fluttertoast.showToast(msg: "Please  register ");
    }
  }
}
