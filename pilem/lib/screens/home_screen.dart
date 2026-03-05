import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];

  Future <void> _loadMovies() async{
    final List<Map<String, dynamic>> _allMoviesData = await _apiService.getAllMovies();
    final List<Map<String, dynamic>> _trendingMoviesData = await _apiService.getTrendingMovies();
    final List<Map<String, dynamic>> _popularMoviesData = await _apiService.getPopularMovies();

    setState(() {
      
    _allMovies = _allMoviesData.map((e)=> Movie.fromJson(e)).toList();
    _trendingMovies = _trendingMoviesData.map((e)=> Movie.fromJson(e)).toList();
    _popularMovies = _popularMoviesData.map((e)=> Movie.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}