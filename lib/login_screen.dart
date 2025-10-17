// login_screen.dart

import 'package:flutter/material.dart';
import 'auth_service.dart'; // Importando o AuthService

class LoginScreen extends StatelessWidget {
  final AuthService authService; // Adicionando AuthService como parâmetro

  const LoginScreen(this.authService, {super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome de Usuário'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validar login
                authService.login(
                  nameController.text,
                  passwordController.text,
                );

                // Verifica se o login foi bem-sucedido
                if (authService.isAuthenticated) {
                  Navigator.pop(context); // Retornar para a tela anterior
                  // Atualizar a tela
                  (context as Element).markNeedsBuild(); // Forçar a atualização da tela
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login inválido!')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}