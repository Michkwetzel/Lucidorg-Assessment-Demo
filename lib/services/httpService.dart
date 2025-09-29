import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class HttpService {
  static final Logger logger = Logger("HttpService");

  static Future<dynamic> getRequest({required String path, Map<String, String>? queryParams, Map<String, String>? additionalHeaders}) async {
    // Build URI with query parameters if provided
    Uri uri;
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = Uri.parse(path).replace(queryParameters: queryParams);
    } else {
      uri = Uri.parse(path);
    }

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    // Add additional headers if provided
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    try {
      logger.info("GET Request: URL=$uri, Headers=${headers.toString()}");

      final response = await http.get(uri, headers: headers);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      logger.severe('Network error: ${e.message}');
      throw HttpRequestException('Network error: Unable to connect to server. Details: ${e.message}');
    } catch (e) {
      logger.severe('Unexpected error: ${e.toString()}');
      throw HttpRequestException(e.toString());
    }
  }

  static Future<dynamic> postRequest({required String path, required Map<String, dynamic> request, Map<String, String>? additionalHeaders}) async {
    final uri = Uri.parse(path);
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    // Add additional headers if provided
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    try {
      logger.info("POST Request: URL=$uri, Body=${jsonEncode(request)} Headers=${headers.toString()}");

      final response = await http.post(uri, headers: headers, body: jsonEncode(request));

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      logger.severe('Network error: ${e.message}');
      throw HttpRequestException('Network error: Unable to connect to server. Details: ${e.message}');
    } catch (e) {
      logger.severe('Unexpected error: ${e.toString()}');
      //throw HttpRequestException(e.toString());
    }
  }

  /// Handles the HTTP response with comprehensive error checking
  static dynamic _handleResponse(http.Response response) {
    logger.info("Response Status Code: ${response.statusCode}");
    logger.info("Response Body: ${response.body}");

    switch (response.statusCode) {
      case 200:
        try {
          return jsonDecode(response.body);
        } catch (e) {
          logger.severe('JSON parsing error: ${e.toString()}');
          throw const HttpRequestException('Error parsing server response');
        }
      case 400:
        throw HttpRequestException('Bad Request: ${_extractErrorMessage(response)}');
      case 401:
        throw HttpRequestException('Unauthorized: ${_extractErrorMessage(response)}');
      case 403:
        throw HttpRequestException('Forbidden: ${_extractErrorMessage(response)}');
      case 404:
        throw HttpRequestException('Resource Not Found: ${_extractErrorMessage(response)}');
      case 500:
        throw HttpRequestException('Server Error: ${_extractErrorMessage(response)}');
      default:
        throw HttpRequestException('Unexpected server response: ${response.statusCode}, Body: ${response.body}');
    }
  }

  /// Attempts to extract a meaningful error message from the response body
  static String _extractErrorMessage(http.Response response) {
    try {
      final errorBody = jsonDecode(response.body);
      return errorBody['message'] ?? errorBody['error'] ?? response.body;
    } catch (_) {
      return response.body;
    }
  }
}

/// Custom exception for HTTP requests
class HttpRequestException implements Exception {
  final String message;
  const HttpRequestException(this.message);

  @override
  String toString() => 'HttpRequestException: $message';
}
