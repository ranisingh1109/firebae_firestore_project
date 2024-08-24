import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCardDetailsScreen extends StatefulWidget {
  const AddCardDetailsScreen({
    super.key,
  });

  @override
  State<AddCardDetailsScreen> createState() => _AddCardDetailsScreenState();
}

class _AddCardDetailsScreenState extends State<AddCardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Card Details Screen"),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          var data = snapshot.data?.docs.toList();
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(data![index]['image']),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index].id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data[index]['title'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data[index]['description'],
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Price: \$${data[index]['price']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
      backgroundColor: Colors.orange,
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    var cart = FirebaseFirestore.instance;
    return await cart.collection("AddToCard").get();
  }
}
