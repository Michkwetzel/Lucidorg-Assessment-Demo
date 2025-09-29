class AuthService {
  static String? _jwtToken;

  /// Set the JWT token (called during app initialization)
  static void setJwtToken(String token) {
    _jwtToken = token;
  }

  /// Get the current JWT token
  static String? get jwtToken => _jwtToken;

  /// Get authorization headers for HTTP requests
  static Map<String, String> getAuthHeaders() {
    if (_jwtToken == null) {
      return {};
    }
    return {'Authorization': 'Bearer $_jwtToken'};
  }

  /// Check if we have a valid token
  static bool get hasToken => _jwtToken != null;
}