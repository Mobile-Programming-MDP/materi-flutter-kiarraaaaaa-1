import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          user != null
              ? "Login sebagai: ${user.email}"
              : "Tidak ada user",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}