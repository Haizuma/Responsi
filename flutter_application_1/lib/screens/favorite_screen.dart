import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, String>> favoriteRestaurants = [
    {
      'id': '1',
      'name': 'Melting Pot',
      'city': 'Medan',
      'pictureId': 'https://restaurant-api.dicoding.dev/images/small/14',
    },
    {
      'id': '2',
      'name': 'Kafe Kita',
      'city': 'Gorontalo',
      'pictureId': 'https://restaurant-api.dicoding.dev/images/small/25',
    },
  ];

  void _removeFromFavorites(String id) {
    setState(() {
      favoriteRestaurants.removeWhere((restaurant) => restaurant['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restoran berhasil dihapus dari Favorite!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
        backgroundColor: Colors.pink.shade400,
      ),
      body: favoriteRestaurants.isEmpty
          ? Center(
              child: Text(
                'Tidak ada restoran favorit.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favoriteRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = favoriteRestaurants[index];
                return _buildFavoriteCard(
                  context,
                  id: restaurant['id']!,
                  name: restaurant['name']!,
                  city: restaurant['city']!,
                  imageUrl: restaurant['pictureId']!,
                );
              },
            ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context, {
    required String id,
    required String name,
    required String city,
    required String imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.broken_image,
              size: 60,
              color: Colors.grey,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        subtitle: Text(
          city,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _removeFromFavorites(id);
          },
        ),
      ),
    );
  }
}
