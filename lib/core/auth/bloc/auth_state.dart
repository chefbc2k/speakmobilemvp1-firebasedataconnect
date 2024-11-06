abstract class AuthState {
  final bool isAuthenticated;
  final bool isAdmin;
  
  const AuthState({
    required this.isAuthenticated,
    required this.isAdmin,
  });
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(isAuthenticated: false, isAdmin: false);
}

class AuthAuthenticated extends AuthState {
  final String userId;
  
  const AuthAuthenticated({
    required this.userId,
    required super.isAdmin,
  }) : super(isAuthenticated: true);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated() : super(isAuthenticated: false, isAdmin: false);
}
