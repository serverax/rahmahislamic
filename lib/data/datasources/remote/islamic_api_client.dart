import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/env.dart';

/// Client for islamicapi.com.
///
/// SCAFFOLD ONLY. The endpoint paths and response shapes here are taken
/// from the public docs and have not been verified against a live response
/// by this codebase. Smoke-test each method against the real API before
/// relying on it in UI:
///
///   curl -H "Authorization: Bearer $ISLAMIC_API_KEY" \
///        https://islamicapi.com/api/asma-ul-husna
///
/// Reads the API key from `Env.islamicApiKey` (loaded from `.env`).
/// Methods throw [IslamicApiException] on non-200 or missing key.
///
/// Usage:
///   - 99 Names of Allah is intentionally NOT consumed by the Adhkar slice
///     (the existing local JSON at assets/data/names_of_allah.json is the
///     canonical source — works offline, scholar-reviewable). This client
///     is here for the future Zakat (Slice 7+) and Ramadan features.
class IslamicApiClient {
  IslamicApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _base = 'https://islamicapi.com/api';

  Map<String, String> get _headers {
    final key = Env.islamicApiKey;
    if (key.isEmpty) {
      throw IslamicApiException('ISLAMIC_API_KEY missing from .env');
    }
    return {
      'Authorization': 'Bearer $key',
      'Accept': 'application/json',
    };
  }

  /// 99 Names of Allah (Asma ul-Husna).
  /// Returns the raw `names` list from the API.
  Future<List<Map<String, dynamic>>> get99Names() async {
    final res = await _client
        .get(Uri.parse('$_base/asma-ul-husna'), headers: _headers)
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw IslamicApiException('asma-ul-husna HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (body['names'] as List<dynamic>?) ?? const [];
    return list.cast<Map<String, dynamic>>();
  }

  /// Current Zakat / Nisab thresholds (gold + silver prices).
  /// Reserved for the Zakat calculator feature (Slice 7+).
  Future<Map<String, dynamic>> getZakatNisab() async {
    final res = await _client
        .get(Uri.parse('$_base/zakat-nisab'), headers: _headers)
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw IslamicApiException('zakat-nisab HTTP ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Ramadan / fasting times for a given location and month.
  /// Reserved for the Ramadan tracker feature (Slice 7+).
  Future<Map<String, dynamic>> getFastingTimes({
    required double latitude,
    required double longitude,
    required int year,
    required int month,
  }) async {
    final uri = Uri.parse('$_base/fasting').replace(queryParameters: {
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'year': year.toString(),
      'month': month.toString(),
    });
    final res = await _client
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw IslamicApiException('fasting HTTP ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  void dispose() => _client.close();
}

class IslamicApiException implements Exception {
  IslamicApiException(this.message);
  final String message;
  @override
  String toString() => 'IslamicApiException: $message';
}
