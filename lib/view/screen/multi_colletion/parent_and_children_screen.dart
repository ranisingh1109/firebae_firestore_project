import 'package:firebae_firestore_project/conttroller/multi_collection_firestore.dart';
import 'package:flutter/material.dart';

class ParentAndChildrenScreen extends StatefulWidget {

  const ParentAndChildrenScreen({super.key,});

  @override
  State<ParentAndChildrenScreen> createState() =>
      _ParentAndChildrenScreenState();
}

class _ParentAndChildrenScreenState extends State<ParentAndChildrenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent And Children Screen"),
      ),
      body: StreamBuilder(
        stream: MultiCollectionFirestore().getFireStoreP(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data?.docs.toList();
          return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) {
              var parent = data[index];
              return Card(
                child: Column(
                  children: [
                    Text("Name:- ${parent["name"]}"),
                    Text("Email:- ${parent["email"]}"),
                    Text("Phone:- ${parent["phone"]}"),
                    Text("Gender:- ${parent["gender"]}"),
                    const SizedBox(height: 20),
                    const Text(
                      "Children",
                      style: TextStyle(fontSize: 20),
                    ),
                    StreamBuilder(
                      stream: MultiCollectionFirestore()
                          .getFireStoreChild(parent.id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        var childrenData = snapshot.data?.docs.toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: childrenData!.length,
                          itemBuilder: (context, index) {
                            var child = childrenData[index];
                            return Card(
                              child: Column(
                                children: [
                                  Text("Name:- ${child["name"]}"),
                                  Text("Email:- ${child["email"]}"),
                                  Text("Phone:- ${child["phone"]}"),
                                  Text("Gender:- ${child["gender"]}"),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
