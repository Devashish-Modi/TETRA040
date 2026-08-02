import 'package:flutter/foundation.dart';

class AuthUser {
  final String displayName;
  final String? phone;
  final String? username;
  final bool isGuest;

  const AuthUser({
    required this.displayName,
    this.phone,
    this.username,
    this.isGuest = false,
  });
}

class _StoredAccount {
  final String? phone;
  final String? username;
  final String password;
  final String displayName;

  const _StoredAccount({
    this.phone,
    this.username,
    required this.password,
    required this.displayName,
  });
}

class AuthController extends ChangeNotifier {
  AuthUser? user;

  bool get isLoggedIn => user != null;
  bool get isGuest => user?.isGuest == true;

  /// Local demo accounts (until Supabase auth is connected).
  final List<_StoredAccount> _accounts = [
    const _StoredAccount(
      phone: '9876543210',
      username: 'ramesh',
      password: 'farm1234',
      displayName: 'Ramesh Patil',
    ),
    const _StoredAccount(
      phone: '9123456789',
      username: 'farmer',
      password: 'farm1234',
      displayName: 'Farm User',
    ),
  ];

  String? loginWithPhone(String phoneRaw, String password) {
    final phone = phoneRaw.replaceAll(RegExp(r'\D'), '');
    if (phone.length < 10) return 'invalid_phone';
    if (password.length < 4) return 'password_short';

    _StoredAccount? match;
    for (final a in _accounts) {
      if (a.phone == phone && a.password == password) {
        match = a;
        break;
      }
    }
    if (match == null) return 'wrong_phone_password';

    user = AuthUser(
      displayName: match.displayName,
      phone: match.phone,
      username: match.username,
    );
    notifyListeners();
    return null;
  }

  String? loginWithUsername(String usernameRaw, String password) {
    final username = usernameRaw.trim().toLowerCase();
    if (username.length < 3) return 'invalid_username';
    if (password.length < 4) return 'password_short';

    _StoredAccount? match;
    for (final a in _accounts) {
      if (a.username != null &&
          a.username!.toLowerCase() == username &&
          a.password == password) {
        match = a;
        break;
      }
    }
    if (match == null) return 'wrong_username_password';

    user = AuthUser(
      displayName: match.displayName,
      phone: match.phone,
      username: match.username,
    );
    notifyListeners();
    return null;
  }

  String? register({
    required String displayName,
    required String password,
    String? phoneRaw,
    String? usernameRaw,
    required bool usePhone,
  }) {
    final name = displayName.trim();
    if (name.length < 2) return 'enter_name';
    if (password.length < 4) return 'password_short';

    if (usePhone) {
      final phone = (phoneRaw ?? '').replaceAll(RegExp(r'\D'), '');
      if (phone.length < 10) return 'invalid_phone';
      if (_accounts.any((a) => a.phone == phone)) {
        return 'phone_registered';
      }
      _accounts.add(_StoredAccount(
        phone: phone,
        password: password,
        displayName: name,
      ));
      user = AuthUser(displayName: name, phone: phone);
    } else {
      final username = (usernameRaw ?? '').trim().toLowerCase();
      if (username.length < 3) return 'username_short';
      if (_accounts.any(
          (a) => a.username?.toLowerCase() == username)) {
        return 'username_taken';
      }
      _accounts.add(_StoredAccount(
        username: username,
        password: password,
        displayName: name,
      ));
      user = AuthUser(displayName: name, username: username);
    }
    notifyListeners();
    return null;
  }

  void loginAsGuest() {
    user = const AuthUser(displayName: 'Guest Farmer', isGuest: true);
    notifyListeners();
  }

  void signOut() {
    user = null;
    notifyListeners();
  }
}
