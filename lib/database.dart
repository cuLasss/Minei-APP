// database.dart

class User {
  String name;
  String password;
  String profilePicture; // Caminho da foto de perfil

  User({
    required this.name,
    required this.password,
    required this.profilePicture,
  });
}

class Database {
  // Lista para armazenar os usuários
  final List<User> _users = [];

  // Método para adicionar um usuário ao banco
  bool addUser(User user) {
    // Verifica se o nome de usuário já existe
    if (_users.any((existingUser) => existingUser.name == user.name)) {
      return false; // Usuário já existe
    }
    _users.add(user);
    return true; // Usuário adicionado com sucesso
  }

  // Método para validar o login
  User? validateUser(String name, String password) {
    try {
      return _users.firstWhere(
        (user) => user.name == name && user.password == password,
      );
    } catch (e) {
      return null; // Retorna null se o usuário não for encontrado
    }
  }
}