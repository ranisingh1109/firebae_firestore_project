import 'dart:async';
import 'package:firebae_firestore_project/view/screen/dynamic_link/product_detals_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'all_product_details_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      getLink();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<PendingDynamicLinkData?> getLink() async {
    final PendingDynamicLinkData? getDynamicLink =
    await FirebaseDynamicLinks.instance.getInitialLink();

    if (getDynamicLink?.link!= null) {

      Fluttertoast.showToast(msg: getDynamicLink!.link.toString());

      final Uri? deepLink = getDynamicLink.link;

      final id = deepLink?.queryParameters['productId'];

      if (id != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              productId: id,
              image: '',
              title: '',
              desc: '',
              price: 0, // Provide a default value here
            ),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AllProductDetailsScreen()), // Replace DynamicLinkScreen with your main screen widget
      );
    }
    return null;
  }
}
