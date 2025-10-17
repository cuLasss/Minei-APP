import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'tutorial_screen.dart';
import 'report_bug_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Escolha uma opção:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildHelpOption(
                context,
                'Entrar em contato com o suporte',
                'https://api.whatsapp.com/send/?phone=32998136786&text=Bom+dia%2C+tudo+bem%3F+Estou+precisando+de+suporte+ao+uso+do+app+Minei%2C+voc%C3%AA+pode+me+ajudar+por+favor%3F&type=phone_number&app_absent=0',
              ),
              const SizedBox(height: 20),
              _buildHelpOption(context, 'Ajuda para uso do app', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TutorialScreen()),
                );
              }),
              const SizedBox(height: 20),
              _buildHelpOption(context, 'Encontrou algum bug?', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportBugScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpOption(BuildContext context, String option, dynamic action) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      onPressed: () {
        if (action is String) {
          _launchURL(action); // Para URLs
        } else if (action is Function) {
          action(); // Para funções
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Você selecionou: $option')),
          );
        }
      },
      child: Text(
        option,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }
}
