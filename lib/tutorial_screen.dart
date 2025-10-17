import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _tutorialPages = [
    "Bem-vindo ao app Minei!\n\nAqui está uma breve introdução ao que você pode fazer.",
    "Botão 1: Entrar em contato com o suporte.\n\nUse este botão para iniciar uma conversa no WhatsApp.",
    "Botão 2: Ajuda para uso do app.\n\nClique aqui para ver as instruções de uso.",
    "Botão 3: Encontrou algum bug?\n\nNos avise para que possamos corrigir o problema.",
  ];

  void _nextPage() {
    if (_currentPage < _tutorialPages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  void _skipTutorial() {
    Navigator.pop(context); // Voltar para a tela principal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
        actions: [
          TextButton(
            onPressed: _skipTutorial,
            child: const Text('Pular', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _tutorialPages.length,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _tutorialPages[index],
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _previousPage,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _nextPage,
            ),
          ],
        ),
      ),
    );
  }
}
