import 'package:flutter/material.dart';
import 'DetailPage.dart';
import 'Character.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Character> _searchResults = [];
  bool _isLoading = false;
  bool _hasError = false;

  Future<List<Character>> searchCharacters(String query) async {
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character/?name=$query'),
    );

    if (response.statusCode == 200) {
      List<Character> characters = [];
      final data = json.decode(response.body);
      if (data['results'] != null) {
        for (var character in data['results']) {
          characters.add(Character.fromJson(character));
        }
      }
      return characters;
    } else {
      throw Exception('Failed to load search results');
    }
  }

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _searchResults = [];
    });

    try {
      _searchResults = await searchCharacters(query);
    } catch (e) {
      _hasError = true;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Characters',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? const Center(
                        child: Text(
                          'Error loading search results.',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : _searchResults.isEmpty
                        ? const Center(
                            child: Text(
                              'No characters found.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              var character = _searchResults[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                elevation: 2,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: Text(
                                    character.name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    character.species,
                                    style: const TextStyle(color: Colors.blueGrey),
                                  ),
                                  leading: ClipOval(
                                    child: Image.network(
                                      character.image,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(character: character),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
