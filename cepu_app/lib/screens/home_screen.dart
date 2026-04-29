import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import 'add_post_screen.dart';
import 'sign_in_screen.dart' as signin;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _service = PostService();

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const signin.SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cepu App - Hi, ${user?.email ?? user?.displayName ?? 'User'}!",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder<List<Post>>(
          stream: _service.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              );
            }

            final posts = snapshot.data ?? [];

            if (posts.isEmpty) {
              return const Center(
                child: Text(
                  'No posts yet',
                ),
              );
            }

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  child: ListTile(
                    leading: post.image.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                              post.image,
                            ),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.image),
                          ),
                    title: Text(post.description),
                    subtitle: Text(
                      '${post.category} • ${post.userFullname}',
                    ),
                    trailing: post.createdAt != null
                        ? Text(
                            _formatTime(
                              post.createdAt!.toDate(),
                            ),
                          )
                        : const Text('Now'),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 1) return 'Now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';

    return '${diff.inDays}d ago';
  }
}
