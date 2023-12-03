import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = 'e685bd9f-83a4-429f-bfa1-599dfb152bec';
  final String baseUrl =
      'https://www.dictionaryapi.com/api/v3/references/medical/json';

  ApiService(String s);

  Future<List<dynamic>> fetchDefinition(String word) async {
    final response = await http.get(Uri.parse('$baseUrl/$word?key=$apiKey'));

    if (response.statusCode == 200) {
      // Parse the response
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load definition');
    }
  }
}
