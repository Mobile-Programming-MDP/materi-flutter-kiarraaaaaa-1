import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String image;
  String description;
  String category;
  double latitude;
  double longitude;
  String userId;
  String userFullname;

  Timestamp? createdAt;
  Timestamp? updatedAt;

  Post({
    this.id,
    required this.image,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.userFullname,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'user_id': userId,
      'user_fullname': userFullname,

      // timestamp
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

  factory Post.fromMap(String id, Map<String, dynamic> map) {
    return Post(
      id: id,
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      userId: map['user_id'] ?? '',
      userFullname: map['user_fullname'] ?? '',
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
