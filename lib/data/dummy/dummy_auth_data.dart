import '../models/user.dart';

/// Dummy authentication data for testing and development
///
/// Test Users:
/// - user_iso / password123 → Iso
/// - user_wainbaru / password123 → Wain Baru
/// - user_disuk / password123 → Disuk
class DummyAuthData {
  /// List of test users with their credentials
  static final List<Map<String, dynamic>> testUsers = [
    {
      'username': 'user_iso',
      'password': 'password123',
      'village_id': '550e8400-e29b-41d4-a716-446655440001',
      'village_name': 'Iso',
    },
    {
      'username': 'user_wainbaru',
      'password': 'password123',
      'village_id': '550e8400-e29b-41d4-a716-446655440002',
      'village_name': 'Wain Baru',
    },
    {
      'username': 'user_disuk',
      'password': 'password123',
      'village_id': '550e8400-e29b-41d4-a716-446655440003',
      'village_name': 'Disuk',
    },
  ];

  /// Validate login credentials
  static bool validateCredentials(String username, String password) {
    try {
      final user = testUsers.firstWhere(
        (u) => u['username'] == username && u['password'] == password,
      );
      return user.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get user data by username
  static Map<String, dynamic>? getUserByUsername(String username) {
    try {
      return testUsers.firstWhere((u) => u['username'] == username);
    } catch (e) {
      return null;
    }
  }

  /// Generate mock JWT token
  static String generateMockToken(String username) {
    // Mock JWT token format: header.payload.signature
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJ1c2VybmFtZSI6IiR1c2VybmFtZSIsInRpbWVzdGFtcCI6JHRpbWVzdGFtcH0.'
        'mock_signature_${username}_$timestamp';
  }

  /// Mock login response
  static Map<String, dynamic> mockLoginResponse(
    String username,
    String password,
  ) {
    if (validateCredentials(username, password)) {
      final user = getUserByUsername(username)!;
      return {
        'token': generateMockToken(username),
        'message': 'Login berhasil',
        'user': User(
          username: username,
          villageId: user['village_id'] as String,
        ).toJson(),
      };
    } else {
      throw Exception('Username atau password salah');
    }
  }

  /// Mock register response
  static Map<String, dynamic> mockRegisterResponse(
    String username,
    String password,
    String villageId,
  ) {
    // Check if username already exists
    final existingUser = getUserByUsername(username);
    if (existingUser != null) {
      throw Exception('Username sudah terdaftar');
    }

    return {
      'message': 'Registrasi berhasil',
      'user': User(
        username: username,
        villageId: villageId,
      ).toJson(),
    };
  }

  /// Get all test users (without passwords, for display purposes)
  static List<Map<String, String>> getTestUsersList() {
    return testUsers.map((u) => {
      'username': u['username'] as String,
      'village_name': u['village_name'] as String,
      'password': '********', // Hidden for security
    }).toList();
  }

  /// Get test credentials for documentation
  static String getTestCredentialsInfo() {
    final buffer = StringBuffer();
    buffer.writeln('Test Credentials:');
    buffer.writeln('');
    for (var user in testUsers) {
      buffer.writeln('Village: ${user['village_name']}');
      buffer.writeln('  Username: ${user['username']}');
      buffer.writeln('  Password: ${user['password']}');
      buffer.writeln('');
    }
    return buffer.toString();
  }
}
