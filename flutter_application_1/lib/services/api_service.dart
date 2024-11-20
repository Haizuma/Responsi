import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<List<dynamic>> fetchData(String menu) async {
    final url = Uri.parse('$_baseUrl/list');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('restaurants')) {
          return jsonData['restaurants'];
        } else {
          throw Exception('Key "restaurants" tidak ditemukan dalam respons.');
        }
      } else {
        throw Exception(
            'Gagal memuat data $menu. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat memuat data $menu: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDetail(String menu, String id) async {
    final url = Uri.parse('$_baseUrl/detail/$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('restaurant')) {
          return jsonData['restaurant'];
        } else {
          throw Exception('Key "restaurant" tidak ditemukan dalam respons.');
        }
      } else {
        throw Exception(
            'Gagal memuat detail $menu dengan ID $id. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat memuat detail $menu dengan ID $id: $e');
    }
  }

  Future<List<dynamic>> searchData(String query) async {
    final url = Uri.parse('$_baseUrl/search?q=$query');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('restaurants')) {
          return jsonData['restaurants'];
        } else {
          throw Exception(
              'Key "restaurants" tidak ditemukan dalam hasil pencarian.');
        }
      } else {
        throw Exception(
            'Gagal mencari restoran dengan query "$query". Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Kesalahan saat mencari restoran dengan query "$query": $e');
    }
  }
}
