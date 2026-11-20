enum UserRole {
  client,
  editor;

  String get displayName => this == UserRole.client ? 'Client' : 'Video Editor';
}

class UserSession {
  final int id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final UserRole role;
  final String token;

  const UserSession({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    required this.token,
  });

  factory UserSession.fromJson(Map<String, dynamic> json, String token) {
    final roleStr = (json['role'] ?? 'client').toString().toLowerCase();
    return UserSession(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 1,
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? 'QuickEdit User',
      avatarUrl: json['avatar_url'],
      role: roleStr == 'editor' ? UserRole.editor : UserRole.client,
      token: token,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'full_name': fullName,
    'avatar_url': avatarUrl,
    'role': role.name,
    'token': token,
  };
}

class TokenStorage {
  static UserSession? _currentSession;

  static UserSession? get currentSession => _currentSession;
  static bool get isAuthenticated => _currentSession != null;
  static String? get token => _currentSession?.token;

  static void saveSession(UserSession session) {
    _currentSession = session;
  }

  static void clearSession() {
    _currentSession = null;
  }
}
