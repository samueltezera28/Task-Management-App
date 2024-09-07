import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String _url = 'https://api.quotable.io/random';

  Future<String> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['content'];
      } else if (response.statusCode == 404) {
        return 'Quote not found. Try again later!';
      } else if (response.statusCode == 500) {
        return 'Server error. Please try again later!';
      } else {
        return 'Unexpected error occurred. Please try again!';
      }
    } catch (e) {
      return 'Failed to load quote. Please check your internet connection.';
    }
  }
}
