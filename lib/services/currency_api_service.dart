import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/exchange_rate.dart';

// ============================================================================
// ❌ BAD PRACTICES IN FLUTTER REST APIS (AVOID THESE!)
// ============================================================================
//
// 1. AVOID: Calling http.get() directly inside a Widget's build() method:
//    - Every time the screen rebuilds (e.g., setState, keyboard opens, or animation),
//      build() runs again, firing infinite API calls and draining battery/rate limits!
//
// 2. AVOID: Using raw Map<String, dynamic> everywhere without a model class:
//    - Example: Text(response['rates']['EUR'].toString())
//    - If the API changes or returns null, your app crashes with NoSuchMethodError.
//
// 3. AVOID: Ignoring HTTP status codes and network errors:
//    - Assuming every request succeeds without try/catch or status check leads
//      to frozen screens and silent failures.
//
// 4. AVOID: Hardcoding URLs everywhere instead of a single API config layer.
// ============================================================================

// Custom Exception for clean, user-friendly error messages
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

// ============================================================================
// ✅ BEST PRACTICES IN FLUTTER REST APIS (FOLLOW THESE!)
// ============================================================================
class CurrencyApiService {
  // 1. Centralized base URL & configuration
  static const String _baseUrl = 'https://api.frankfurter.app';
  static const Duration _timeoutDuration = Duration(seconds: 10);

  final http.Client _client;

  // Dependency injection: accepts custom client (useful for mock unit testing!)
  CurrencyApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches live exchange rates for a given base currency (e.g. 'USD')
  Future<List<CurrencyRate>> fetchLiveExchangeRates({String base = 'USD'}) async {
    final Uri url = Uri.parse('$_baseUrl/latest?from=$base');

    try {
      // 2. Add network timeouts to prevent requests hanging indefinitely
      final response = await _client.get(url).timeout(_timeoutDuration);

      // 3. Check HTTP Status Codes explicitly
      if (response.statusCode == 200) {
        // 4. Safely decode JSON payload
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> ratesMap = data['rates'] as Map<String, dynamic>;

        // 5. Convert JSON into strongly-typed Dart model objects
        final List<CurrencyRate> rates = ratesMap.entries
            .map((entry) => CurrencyRate.fromJson(entry.key, entry.value as num))
            .toList();

        return rates;
      } else if (response.statusCode == 404) {
        throw ApiException('Currency data not found', 404);
      } else if (response.statusCode >= 500) {
        throw ApiException('Server error. Please try again later', response.statusCode);
      } else {
        throw ApiException('Failed to load rates (${response.statusCode})', response.statusCode);
      }
    } on SocketException {
      // No internet connection
      throw ApiException('No internet connection. Please check your network.');
    } on TimeoutException {
      // Request took too long
      throw ApiException('Connection timed out. Server took too long to respond.');
    } on FormatException {
      // Invalid JSON format
      throw ApiException('Invalid response format from server.');
    } catch (e) {
      // Catch-all for unexpected issues
      if (e is ApiException) rethrow;
      throw ApiException('An unexpected error occurred: $e');
    }
  }
}
