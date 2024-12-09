import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mars_weather.dart';

class MarsService {
  final String apiKey;

  MarsService(this.apiKey);

  // Récupérer les données météo de Mars
  Future<MarsWeather?> fetchMarsWeather() async {
    final url = Uri.parse(
        'https://api.nasa.gov/insight_weather/?api_key=$apiKey&feedtype=json&ver=1.0');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final solKeys = data['sol_keys'] as List<dynamic>;
        if (solKeys.isNotEmpty) {
          final latestSol = solKeys.last;
          return MarsWeather.fromJson(data[latestSol]);
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des données météo : $e');
    }
    return null;
  }

  // Récupérer les images des rovers
  Future<List<String>> fetchRoverImages(String rover, DateTime date) async {
    final String formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final url = Uri.parse(
        'https://api.nasa.gov/mars-photos/api/v1/rovers/$rover/photos?earth_date=$formattedDate&api_key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(
            data['photos'].map((photo) => photo['img_src']));
      }
    } catch (e) {
      print('Erreur lors de la récupération des images des rovers : $e');
    }
    return [];
  }
}
