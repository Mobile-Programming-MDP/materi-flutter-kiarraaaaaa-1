import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class FavoriteScreen extends StatefulWidget {
const FavoriteScreen({super.key});

@override
State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
List<Movie> favoriteMovies = [];

@override
void initState() {
super.initState();
loadFavorites();
}

Future<void> loadFavorites() async {
final prefs = await SharedPreferences.getInstance();

List<String> favList = prefs.getStringList('favorites') ?? [];

setState(() {
  favoriteMovies =
      favList.map((movie) => Movie.fromJson(jsonDecode(movie))).toList();
});

}

Future<void> removeFavorite(Movie movie) async {
final prefs = await SharedPreferences.getInstance();

List<String> favList = prefs.getStringList('favorites') ?? [];

favList.removeWhere((item) {
  final decoded = Movie.fromJson(jsonDecode(item));
  return decoded.id == movie.id; // lebih aman pakai id
});

await prefs.setStringList('favorites', favList);

loadFavorites();

}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Favorite Movies"),
centerTitle: true,
),
body: favoriteMovies.isEmpty
? const Center(
child: Text("No favorite movies yet"),
)
: ListView.builder(
itemCount: favoriteMovies.length,
itemBuilder: (context, index) {
final movie = favoriteMovies[index];

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: Image.network(
                  "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(movie.title),
                subtitle: Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    removeFavorite(movie);
                  },
                ),
              ),
            );
          },
        ),
);

}
}
