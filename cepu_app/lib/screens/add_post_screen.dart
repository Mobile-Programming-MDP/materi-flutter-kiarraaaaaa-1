import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final descController = TextEditingController();
  final categoryController = TextEditingController();

  final PostService _service = PostService();

  Position? _currentPosition;
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services disabled')));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')));
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Location: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}')));
  }

  void submit() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Harus login dulu')));
      setState(() => _isLoading = false);
      return;
    }

    double lat = _currentPosition?.latitude ?? 0.0;
    double lng = _currentPosition?.longitude ?? 0.0;

    Post post = Post(
      image: "dummy.jpg", // TODO: integrate image_picker
      description: descController.text.trim(),
      category: categoryController.text.trim(),
      latitude: lat,
      longitude: lng,
      userId: user.uid,
      userFullname: user.displayName ?? user.email ?? 'User',
    );

    final error = await _service.addPost(post);
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post berhasil dibuat!')));
      Navigator.pop(context);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : submit,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ))
                  : const Text("Save"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: Text(_currentPosition == null
                  ? 'Get Location'
                  : 'Location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'),
            ),
          ],
        ),
      ),
    );
  }
}
