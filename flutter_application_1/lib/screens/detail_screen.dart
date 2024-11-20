import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class DetailScreen extends StatelessWidget {
  final String menu;
  final String id;

  DetailScreen({
    required this.menu,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Detail Restaurant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.blue.shade900,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue.shade900),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {
              _addToFavorites(context, id);
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService().fetchDetail(menu, id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null ||
              snapshot.data!['restaurant'] == null) {
            return Center(child: Text('Data tidak ditemukan.'));
          } else {
            final data = snapshot.data!['restaurant'];
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(data['pictureId']),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? 'No Name',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${data['city'] ?? 'Unknown City'}, ${data['address'] ?? 'Unknown Address'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Rating: ${data['rating']?.toString() ?? '-'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          data['description'] ?? 'No Description Available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          children: (data['categories'] as List<dynamic>? ?? [])
                              .map((category) => Chip(
                                    label: Text(category['name'] ?? '-'),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 24),
                        _buildMenuSection(
                            'Foods', data['menus']?['foods'] ?? []),
                        SizedBox(height: 16),
                        _buildMenuSection(
                            'Drinks', data['menus']?['drinks'] ?? []),
                        SizedBox(height: 24),
                        _buildReviews(data['customerReviews'] ?? []),
                        SizedBox(height: 24),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _launchURL(
                                  'https://maps.google.com/?q=${data['name']}');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.blue.shade700,
                            ),
                            icon: Icon(Icons.location_on, color: Colors.white),
                            label: Text(
                              'Lihat Lokasi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildImage(String? pictureId) {
    final imageUrl = pictureId != null && pictureId.isNotEmpty
        ? 'https://restaurant-api.dicoding.dev/images/large/$pictureId'
        : 'https://via.placeholder.com/300';
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.broken_image,
            size: 250,
            color: Colors.grey,
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(String title, List<dynamic> items) {
    if (items.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        SizedBox(height: 8),
        for (var item in items)
          Text(
            '- ${item['name'] ?? 'Unknown'}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
      ],
    );
  }

  Widget _buildReviews(List<dynamic> reviews) {
    if (reviews.isEmpty) {
      return Text(
        'No Reviews Available',
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        SizedBox(height: 8),
        for (var review in reviews)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review['name'] ?? 'Anonymous',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  review['review'] ?? '-',
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
                Text(
                  review['date'] ?? '-',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Divider(),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _addToFavorites(BuildContext context, String id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restoran berhasil ditambahkan ke Favorite!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
