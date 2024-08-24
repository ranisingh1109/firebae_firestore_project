// import 'dart:ffi';
//
import 'package:firebase_database/firebase_database.dart';

// import 'package:flutter/material.dart';
//
// class RealTimeDatabase extends StatefulWidget {
//   const RealTimeDatabase({super.key});
//
//   @override
//   State<RealTimeDatabase> createState() => _RealTimeDatabaseState();
// }
//
// class _RealTimeDatabaseState extends State<RealTimeDatabase> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("RealTime Database"),
//       ),
//       body: Column(
//         children: [
//
//           Padding(
//             padding: const EdgeInsets.only(top: 650),
//             child: TextFormField(
//               decoration: InputDecoration(
//                   hintText: "Message",
//                   prefix: Icon(Icons.emoji_emotions),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//           ),
//           // ElevatedButton(
//           //     onPressed: () {
//           //       // realTimeDataBase();
//           //     },
//           //     child: Text("Add")),
//           // SizedBox(
//           //   height: 20,
//           // ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(backgroundColor: Colors.teal,
//         onPressed: (){
//
//       },),
//     );
//   }
//
//   realTimeDataBase(String data) async {
//     var realTime = await FirebaseDatabase.instance.ref("students");
//     var id = realTime.push().key;
//     realTime
//         .child(id.toString())
//         .set({"id": id.toString(), "search message": data});
//   }
//
// // realTimeDataBaseD() async {
// //   var realTime = await FirebaseDatabase.instance.ref("user").child("first");
// //   await realTime.set({
// //     "name": " Rani Kumari",
// //     "email": "ranikumari@gmail.com",
// //   });
// //   await realTime.child("address").set({
// //     "village": "JagdishPur",
// //     "post": "Maker",
// //     "district": "Bihar",
// //   });
// //   await realTime.child("gender").set({
// //     "mela": "True",
// //     "female": "False",
// //   });
// // }
// }

import 'package:flutter/material.dart';

class RealTimeDatabase extends StatefulWidget {
  @override
  _RealTimeDatabaseState createState() => _RealTimeDatabaseState();
}

class _RealTimeDatabaseState extends State<RealTimeDatabase> {
  TextEditingController searchMController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                child: Image.asset("assets/Screenshot_2024-07-13-14-29-27-867_com.miui.gallery.jpg",height: 20,)),
            SizedBox(width: 10),
            const Text(
              "RANI KUMARI",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder(
        stream: realTimeDataGet(),
        builder: (context, snapshot) {
          //  var data = snapshot.data?.snapshot.children;
          var data = snapshot.data?.snapshot.children.toList();
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                var massage = data?[index].value as Map;
                return Column(
                  children: [Text("Message:- ${massage['search message']}")],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: searchMController,
                  decoration: InputDecoration(
                    hintText: "Message",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    color: Colors.teal,
                    icon: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.teal,
                    )),
                    onPressed: () {
                      realTimeDataBase(searchMController.text);
                      // Button action here
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  realTimeDataBase(String data) async {
    var realTime = await FirebaseDatabase.instance.ref("chats");
    var id = realTime.push().key;
    realTime.child(id.toString()).set({
      // "id": id.toString(),
      "search message": data,
      "dateTime": DateTime.now().toString(),
    });
  }
  Stream<DatabaseEvent> realTimeDataGet() {
    var realTime = FirebaseDatabase.instance.ref("chats");
    return realTime.onValue;
  }
}
