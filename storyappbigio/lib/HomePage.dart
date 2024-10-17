import 'package:flutter/material.dart';
import 'DetailPage.dart';
import 'Character.dart';
import 'database_helper.dart';
import 'favorite_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Character> _characters = [];
  Set<int> _favoriteCharacterIds = {};
  final dbHelper = DatabaseHelper();
  int _currentPage = 1; 
  bool _isLoading = false; 
  bool _hasMoreCharacters = true; 

  @override
  void initState() {
    super.initState();
    fetchCharacters(); 
    _loadFavoriteIds(); 
  }

  Future<void> fetchCharacters() async {
    if (_isLoading || !_hasMoreCharacters) return; 
    _isLoading = true; 

    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character?page=$_currentPage'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Character> characters = (data['results'] as List)
          .map((character) => Character.fromJson(character))
          .toList();

      setState(() {
        _characters.addAll(characters); 
        _currentPage++; 

        _hasMoreCharacters = characters.length >= 20;
      });
    } else {
      throw Exception('Failed to load characters');
    }
    _isLoading = false; 
  }

  Future<void> _loadFavoriteIds() async {
    final favorites = await dbHelper.getFavorites();
    setState(() {
      _favoriteCharacterIds = favorites.map((fav) => fav.id).toSet();
    });
  }

  void _toggleFavorite(Character character) {
    if (_favoriteCharacterIds.contains(character.id)) {
      dbHelper.deleteFavorite(character.id);
      _favoriteCharacterIds.remove(character.id);
    } else {
      dbHelper.insertFavorite(FavoriteCharacter(
        id: character.id,
        name: character.name,
        species: character.species,
        gender: character.gender,
        origin: character.origin,
        location: character.location,
        image: character.image,
      ));
      _favoriteCharacterIds.add(character.id);
    }
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rick and Morty Characters',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _characters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  fetchCharacters(); 
                }
                return false;
              },
              child: ListView.builder(
                itemCount: _characters.length + (_hasMoreCharacters ? 1 : 0), 
                itemBuilder: (context, index) {
                  if (index == _characters.length) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ); 
                  }

                  var character = _characters[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      title: Text(
                        character.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(character.species),
                      leading: ClipOval(
                        child: Image.network(
                          character.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          _favoriteCharacterIds.contains(character.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _favoriteCharacterIds.contains(character.id)
                              ? Colors.red
                              : null,
                        ),
                        onPressed: () => _toggleFavorite(character),
                      ),
                      onTap: () async {
                        final isFavorite = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(character: character),
                          ),
                        );

                        if (isFavorite != null) {
                          setState(() {
                            if (isFavorite) {
                              _favoriteCharacterIds.add(character.id);
                            } else {
                              _favoriteCharacterIds.remove(character.id);
                            }
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
