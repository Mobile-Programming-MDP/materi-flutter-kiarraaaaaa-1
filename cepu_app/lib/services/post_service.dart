import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../models/post.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = "posts";

  // CREATE POST
  Future<String?> addPost(Post post) async {
    try {
      await _db.collection(collection).add(post.toMap());
      return null;
    } on FirebaseException catch (e) {
      return 'Gagal tambah post: ${e.message}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // READ POSTS
  Stream<List<Post>> getPosts() {
    return _db
        .collection(collection)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Post.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  // UPDATE POST
  Future<String?> updatePost(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await _db.collection(collection).doc(id).update({
        ...data,
        'updated_at': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseException catch (e) {
      return 'Gagal update post: ${e.message}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // DELETE POST
  Future<String?> deletePost(String id) async {
    try {
      await _db.collection(collection).doc(id).delete();
      return null;
    } on FirebaseException catch (e) {
      return 'Gagal hapus post: ${e.message}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // GET SINGLE POST
  Future<Post?> getPostById(String id) async {
    try {
      final doc = await _db.collection(collection).doc(id).get();

      if (!doc.exists) return null;

      return Post.fromMap(
        doc.id,
        doc.data()!,
      );
    } catch (e) {
      debugPrint('Error loading post $id: $e');
      return null;
    }
  }
}
