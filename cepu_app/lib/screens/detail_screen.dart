import 'package:flutter/material.dart';
import '../models/post.dart';

class DetailScreen extends StatelessWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kategori: ${post.category}"),
            const SizedBox(height: 10),
            Text("Deskripsi: ${post.description}"),
            const SizedBox(height: 10),
            Text("User: ${post.userFullname}"),
            const SizedBox(height: 10),
            Text("Lokasi: ${post.latitude}, ${post.longitude}"),
          ],
        ),
      ),
    );
  }
}
