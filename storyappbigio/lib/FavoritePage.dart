import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'favorite_model.dart';
import 'DetailPage.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<FavoriteCharacter> _favoriteCharacters = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await dbHelper.getFavorites();
    setState(() {
      _favoriteCharacters = favorites;
    });
  }

  Future<void> _deleteFavorite(int id) async {
    await dbHelper.deleteFavorite(id);
    await _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Favorite character removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Characters',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _favoriteCharacters.isEmpty
          ? const Center(
              child: Text(
                'No favorite characters found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _favoriteCharacters.length,
              itemBuilder: (context, index) {
                var favorite = _favoriteCharacters[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      favorite.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      favorite.species,
                      style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    leading: ClipOval(
                      child: Image.network(
                        favorite.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () async {
                      final isFavorite = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            character: favorite.toCharacter(),
                          ),
                        ),
                      );

                      if (isFavorite != null) {
                        await _loadFavorites();
                      }
                    },
                    trailing: GestureDetector(
                      onTap: () => _showDeleteConfirmation(favorite.id),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent, 
                          shape: BoxShape.circle, 
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white, 
                          size: 24, 
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Favorite'),
          content: const Text('Are you sure you want to remove this character from favorites?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _deleteFavorite(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
