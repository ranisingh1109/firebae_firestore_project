import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebae_firestore_project/view/screen/dynamic_link/product_detals_screen.dart';
import 'package:flutter/material.dart';

class AllProductDetailsScreen extends StatefulWidget {
  const AllProductDetailsScreen({super.key});

  @override
  State<AllProductDetailsScreen> createState() =>
      _AllProductDetailsScreenState();
}

class _AllProductDetailsScreenState extends State<AllProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dynamic Link Screen",
        ),
        backgroundColor: Colors.orange,
      ),
      body:
      FutureBuilder(
        future: getProductData(),
        builder: (context, snapshot) {
          var data = snapshot.data?.docs;
          if (data?.isNotEmpty == true) {
            return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: data[index].id,
                            image: data[index]["image"],
                            title: data[index]["title"],
                            desc: data[index]['description'],
                            price: data[index]['price'],
                          ),
                        ));
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(data![index]['image']),
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

  Future<QuerySnapshot<Map<String, dynamic>>> getProductData() async {
    var product = FirebaseFirestore.instance;
    return await product.collection("product").get();
  }
}
