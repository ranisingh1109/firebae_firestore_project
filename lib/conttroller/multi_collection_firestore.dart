import 'package:cloud_firestore/cloud_firestore.dart';

class MultiCollectionFirestore{
  firebaseFireStoreP(String name,String email,String phone,String gender)async{
    var firebase = FirebaseFirestore.instance;
    await  firebase.collection("parent").add({
      "name":name,
      "email": email,
      "phone":phone,
      "gender":gender,
    });
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getFireStoreP(){
    var firebase = FirebaseFirestore.instance;
    var  children =  firebase.collection("parent");
    var data = children.snapshots();
    return data;
  }

  firebaseFireStoreChild(String name,String email,String phone,String gender,String parentId)async{
    var firebase = FirebaseFirestore.instance;
    await  firebase.collection("children").add({
      "name":name,
      "email": email,
      "phone":phone,
      "gender":gender,
      'parentId':parentId
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFireStoreChild(String parentId){
    var firebase = FirebaseFirestore.instance;
    var  children =  firebase.collection("children").where("parentId",isEqualTo: parentId);
    var data = children.snapshots();
    return data;
  }
}