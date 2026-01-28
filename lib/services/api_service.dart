import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/release.dart';

class ApiService {
  static const String baseUrl = 'https://app.wipstaf.net/api/releaseDiEmet';

  static Future<List<Release>> fetchReleases() async {
    try {
      print('Fetching releases from: $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'MusikaApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Received ${data.length} releases');
        return data.map((json) => Release.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load releases: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during fetch: $e');
      throw Exception('Error fetching releases: $e');
    }
  }
}
