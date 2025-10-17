import 'package:flutter/material.dart';
import 'database.dart';

// --- Modelo de autenticação ---
class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  final Database _database;
  Database get database => _database;

  AuthService(this._database) {
    // Adicionando um usuário padrão
    _database.addUser(User(
      name: '1234',
      password: '1234',
      profilePicture: 'assets/profile_placeholder.png',
    ));
  }

  bool get isAuthenticated => _isAuthenticated;

  void login(String name, String password) {
    if (_database.validateUser(name, password) != null) {
      _isAuthenticated = true;
      notifyListeners(); // Notifica os widgets interessados sobre a mudança
    }
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners(); // Notifica os widgets interessados sobre a mudança
  }
}