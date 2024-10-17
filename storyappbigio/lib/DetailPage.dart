import 'package:flutter/material.dart';
import 'Character.dart';
import 'database_helper.dart';
import 'favorite_model.dart';

class DetailPage extends StatefulWidget {
  final Character character;

  const DetailPage({super.key, required this.character});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorite = false;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favorite = await dbHelper.isFavorite(widget.character.id);
    setState(() {
      _isFavorite = favorite;
    });
  }

  void _toggleFavorite() async {
    if (_isFavorite) {
      await dbHelper.deleteFavorite(widget.character.id);
    } else {
      await dbHelper.insertFavorite(FavoriteCharacter(
        id: widget.character.id,
        name: widget.character.name,
        species: widget.character.species,
        gender: widget.character.gender,
        origin: widget.character.origin,
        location: widget.character.location,
        image: widget.character.image,
      ));
    }
    setState(() {
      _isFavorite = !_isFavorite; // Toggle favorite status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Character Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _isFavorite);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.network(
                widget.character.image,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.character.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.accessibility, color: Colors.blueGrey),
                      const SizedBox(width: 5),
                      Text(
                        widget.character.species,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.person, color: Colors.blueGrey),
                      const SizedBox(width: 5),
                      Text(
                        widget.character.gender,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'Origin: ${widget.character.origin}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.my_location, color: Colors.orange),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Last known location: ${widget.character.location}',
                          style: const TextStyle(fontSize: 18),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          label: Text(
            _isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: _isFavorite ? Colors.redAccent : Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _toggleFavorite,
        ),
      ),
    );
  }
}
