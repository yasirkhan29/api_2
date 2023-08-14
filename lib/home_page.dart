import 'dart:convert';
import 'package:api_2/models/movies.dart';
import 'package:api_2/widgets/moviesWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class App extends StatefulWidget {
  @override
  _App createState() => _App();
}

class _App extends State<App> {
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _populateAllMovies();
  }

  void _populateAllMovies() async {
    var movies = await _fetchAllMovies();
    setState(() {
      _movies = movies;
    });
  }

  Future<List<Movie>> _fetchAllMovies() async {
    final response = await http.get(
        Uri.parse("http://www.omdbapi.com/?s=Batman&page=2&apikey=564727fa"));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Iterable list = data["Search"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Movies App",
        home: Scaffold(
            appBar: AppBar(title: Text("Movies Testing api")),
            body: MoviesWidget(movies: _movies)));
  }
}
