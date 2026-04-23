import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/note_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteDialog extends StatefulWidget {
  final Note? note;
  const NoteDialog({super.key, this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _base64Image;
  String? _latitude;
  String? _longitude;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _base64Image = widget.note!.imageBase64;
      _latitude = widget.note!.latitude;
      _longitude = widget.note!.longitude;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      String base64String = base64Encode(bytes);
      setState(() {
        _base64Image = base64String;
      });
      print("Image picked and converted to base64");
    }
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location service disabled")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 10));

      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
      });

      print("Location: $_latitude, $_longitude"); // ✅ FIX
    } catch (e) {
      print('Location error: $e'); // ✅ FIX
      setState(() {
        _latitude = null;
        _longitude = null;
      });
    }
  }

  Future<void> openMap() async {
    if (_latitude == null || _longitude == null) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$_latitude,$_longitude',
    ); // ✅ FIX

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Add Note' : 'Update Note'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title:'),
            TextField(controller: _titleController),
            const SizedBox(height: 20),

            const Text('Description:'),
            TextField(controller: _descriptionController),
            const SizedBox(height: 20),

            const Text('Image:'),
            Container(
              height: 200,
              width: 200,
              color: Colors.grey[200],
              child: _base64Image != null
                  ? Image.memory(base64Decode(_base64Image!), fit: BoxFit.cover)
                  : const Center(child: Icon(Icons.add_a_photo, size: 50)),
            ),

            TextButton(onPressed: _pickImage, child: const Text('Pick Image')),
            TextButton(onPressed: _getLocation, child: const Text('Get Location')),

            if (_latitude != null && _longitude != null) ...[
              Text('Location: ($_latitude, $_longitude)'), // ✅ FIX
              TextButton(onPressed: openMap, child: const Text('Open in Maps')),
            ]
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.note == null) {
              NoteService.addNote(
                Note(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  imageBase64: _base64Image,
                  latitude: _latitude,
                  longitude: _longitude,
                ),
              ).whenComplete(() => Navigator.pop(context));
            } else {
              NoteService.updateNote(
                Note(
                  id: widget.note!.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  createdAt: widget.note!.createdAt,
                  updatedAt: widget.note!.updatedAt,
                  imageBase64: _base64Image,
                  latitude: _latitude,
                  longitude: _longitude,
                ),
              ).whenComplete(() => Navigator.pop(context));
            }
          },
          child: Text(widget.note == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}