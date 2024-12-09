import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apod_model.dart';

class ApodService {
  final String _baseUrl = 'https://api.nasa.gov/planetary/apod';
  final String _apiKey = '4aOaBvX6w1ezm561gg42cjm4B6kDVNZwnxMHxeku';

  Future<ApodModel> fetchApod() async {
    final response = await http.get(Uri.parse('$_baseUrl?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ApodModel.fromJson(data);
    } else {
      throw Exception('Failed to load APOD');
    }
  }
}
