import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:dailoz/core/app_constants.dart';
import 'package:dailoz/data/models/quote.dart';

class QuoteApiService {
  final http.Client _client;

  QuoteApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Quote>> getQuotes() async {
    try {
      final response = await _client.get(Uri.parse(AppConstants.quotesApiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Quote.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load quotes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load quotes: $e');
    }
  }
}
