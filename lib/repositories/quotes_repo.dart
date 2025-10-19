import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuotesRepo {
  static Future<Quote?> fetchQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://zenquotes.io/api/random'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        if (data.isNotEmpty) {
          return Quote.fromJson(data[0]);
        }
      }
    } catch (e) {}
    return null;
  }
}
