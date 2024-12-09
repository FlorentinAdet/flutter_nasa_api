import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/searching_model.dart';

class NasaApiService {
  // URL API
  final String baseUrl = 'https://images-api.nasa.gov/search';

  // Fonction pour effectuer une recherche
  Future<List<NasaImage>> searchImages(String query) async {
    final url = Uri.parse('$baseUrl?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Vérification des données
      final items = data['collection']['items'] as List;
      return items
          .map((item) {
            final dataEntry = (item['data'] != null &&
                    item['data'] is List &&
                    item['data'].isNotEmpty)
                ? item['data'][0]
                : null;

            if (dataEntry != null) {
              return NasaImage.fromJson({
                ...dataEntry,
                'links': item['links'], // Ajout des liens d'image
              });
            }
            return null;
          })
          .where((image) => image != null)
          .cast<NasaImage>()
          .toList();
    } else {
      throw Exception('Erreur lors de la recherche : ${response.statusCode}');
    }
  }
}
