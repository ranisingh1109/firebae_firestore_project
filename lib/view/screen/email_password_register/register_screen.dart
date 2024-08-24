import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../conttroller/firebase_firestore_authentication.dart';
import 'homepage_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Enter your Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: "Enter your Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                User? user = await FirebaseFirestoreAuthentication()
                    .loginData(emailController.text, passwordController.text);
                if (user != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          user: user,
                        ),
                      ));
                }
              },
              child: const Text("Register Data"))
        ],
      ),
    );
  }
}
