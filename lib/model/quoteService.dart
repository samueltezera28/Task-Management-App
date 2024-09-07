import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String _url = 'https://api.quotable.io/random';

  Future<String> fetchQuote() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['content'];
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
