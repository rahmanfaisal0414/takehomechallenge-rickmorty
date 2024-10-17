import 'package:flutter_test/flutter_test.dart';
import 'package:storyappbigio/Character.dart'; 
import 'package:storyappbigio/favorite_model.dart'; 

void main() {
  group('Character Class', () {
    test('Character fromJson should parse JSON correctly', () {
      final json = {
        'id': 1,
        'name': 'Rick Sanchez',
        'species': 'Human',
        'gender': 'Male',
        'origin': {'name': 'Earth'},
        'location': {'name': 'Earth'},
        'image': 'https://example.com/rick.png',
      };

      final character = Character.fromJson(json);

      expect(character.id, 1);
      expect(character.name, 'Rick Sanchez');
      expect(character.species, 'Human');
      expect(character.gender, 'Male');
      expect(character.origin, 'Earth');
      expect(character.location, 'Earth');
      expect(character.image, 'https://example.com/rick.png');
    });

    test('Character should have all required properties', () {
      final character = Character(
        id: 1,
        name: 'Rick Sanchez',
        species: 'Human',
        gender: 'Male',
        origin: 'Earth',
        location: 'Earth',
        image: 'https://example.com/rick.png',
      );

      expect(character.id, isA<int>());
      expect(character.name, isA<String>());
      expect(character.species, isA<String>());
      expect(character.gender, isA<String>());
      expect(character.origin, isA<String>());
      expect(character.location, isA<String>());
      expect(character.image, isA<String>());
    });
  });

  group('FavoriteCharacter Class', () {
    test('FavoriteCharacter toMap should convert properties to a map', () {
      final favoriteCharacter = FavoriteCharacter(
        id: 1,
        name: 'Rick Sanchez',
        species: 'Human',
        gender: 'Male',
        origin: 'Earth',
        location: 'Earth',
        image: 'https://example.com/rick.png',
      );

      final map = favoriteCharacter.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'Rick Sanchez');
      expect(map['species'], 'Human');
      expect(map['gender'], 'Male');
      expect(map['origin'], 'Earth');
      expect(map['location'], 'Earth');
      expect(map['image'], 'https://example.com/rick.png');
    });
  });
}
