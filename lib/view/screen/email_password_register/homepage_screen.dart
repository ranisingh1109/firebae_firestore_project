import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final FirebaseAuth loginAuthentication = FirebaseAuth.instance;

  HomeScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              color: Colors.cyan,
              height: 200,
              width: 200,
              child: Center(child: Text('Welcome, ${user.email}!')),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                await loginAuthentication.signOut();
              },
              child: Text("lagOUt"))
        ],
      ),
    );
  }
}
