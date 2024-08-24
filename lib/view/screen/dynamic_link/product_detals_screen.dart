import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'add_card_details_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final String image;
  final String title;
  final String desc;
  final num price;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    required this.image,
    required this.title,
    required this.desc,
    required this.price,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details Screen"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
        future: getProductData(widget.productId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var product = snapshot.data?.data();
            return Card(
              margin: const EdgeInsets.all(10),
              child: Container(
                height: 280,
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 130),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage:
                          NetworkImage(product?["image"] ?? ''),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product?['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product?['description'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'Price: \$${product?['price'] ?? ''}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding: const EdgeInsets.only(left: 80),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.orange),
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.black),
                                ),
                                onPressed: () {
                                  createDynamicLink(product!["id"].toString());
                                },
                                child: const Text("Share item"),
                              ),
                            ),
                            IconButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.orange),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.white),
                              ),
                              onPressed: () {
                                addProduct();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddCardDetailsScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                                size: 70,
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
          }
        },
      ),
      backgroundColor: Colors.orange,
    );
  }

  Future<void> createDynamicLink(String productId) async {
    var parameters = DynamicLinkParameters(
      link: Uri.parse(
          "https://firebaefirestoreproject.page.link/product?productId=$productId"),
      uriPrefix: "https://firebaefirestoreproject.page.link",
      androidParameters: const AndroidParameters(
        minimumVersion: 1,
        packageName: "com.example.firebae_firestore_project",
      ),
    );

    final dynamicLink =
    await FirebaseDynamicLinks.instance.buildLink(parameters);
    await Share.share(dynamicLink.toString());
  }

  addProduct() async {
    var inst = FirebaseFirestore.instance;
    await inst.collection("AddToCard").add({
      "productId": widget.productId,
      "image": widget.image,
      "title": widget.title,
      "description": widget.desc,
      "price": widget.price,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getProductData(
      String id2) async {
    var product = FirebaseFirestore.instance;
    return await product.collection("product").doc(id2).get();
  }
}
