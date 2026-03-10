import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilem/models/movie.dart';

class DetailScreen extends StatelessWidget {
final Movie movie;
const DetailScreen({super.key, required this.movie});

Future<bool> addFavorite(Movie movie) async {
final prefs = await SharedPreferences.getInstance();
List<String> favList = prefs.getStringList('favorites') ?? [];

bool alreadyExist = favList.any((item) {
  final decoded = Movie.fromJson(jsonDecode(item));
  return decoded.id == movie.id;
});

if (!alreadyExist) {
  favList.add(jsonEncode(movie.toJson()));
  await prefs.setStringList('favorites', favList);
  return true;
}

return false;

}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(movie.title),
actions: [
IconButton(
icon: const Icon(Icons.favorite_border),
onPressed: () async {
bool added = await addFavorite(movie);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                added ? "Added to Favorite" : "Already in Favorite",
              ),
            ),
          );
        },
      )
    ],
  ),
  body: Padding(
    padding: const EdgeInsets.all(8.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            'Overview:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(movie.overview),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.blue),
              const SizedBox(width: 10),
              const Text(
                'Release Date:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Text(movie.releaseDate),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 10),
              const Text(
                'Rating:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Text(movie.voteAverage.toString()),
            ],
          ),
        ],
      ),
    ),
  ),
);

}
}
