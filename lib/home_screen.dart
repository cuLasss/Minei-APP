import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'atualizar_preços.dart';
import 'auth_service.dart';
import 'comparar_preços.dart';
import 'login_screen.dart';
import 'cadastro_screen.dart';
import 'help_screen.dart';
import 'minha_lista_compras.dart';
import 'tela_mercados.dart';
import 'theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isMenuOpen = false;
  bool _isExclamationOpen = false;

  late AnimationController _menuAnimationController;
  late AnimationController _exclamationAnimationController;
  late AnimationController _exclamationOptionsController;

  @override
  void initState() {
    super.initState();
    _initializeAnimationControllers();
  }

  @override
  void dispose() {
    _disposeAnimationControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthService>(context); // Obtenha o AuthService
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Obtenha o ThemeProvider

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildAppBar(screenWidth),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _handleTapOutsideMenus,
            child: Container(
              color: Colors.transparent,
              child: authService.isAuthenticated
                  ? _buildShoppingList() // Mostrar lista de compras se autenticado
                  : _buildBodyContent(
                      themeProvider), // Mostrar conteúdo padrão se não autenticado
            ),
          ),
          _buildSideMenu(screenWidth),
          _buildExclamationButton(),
          if (_isExclamationOpen) _buildExclamationOptions(),
        ],
      ),
    );
  }

  // --- Inicialização de Animações ---
  void _initializeAnimationControllers() {
    _menuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _exclamationAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exclamationOptionsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  // --- Destruição de Animações ---
  void _disposeAnimationControllers() {
    _menuAnimationController.dispose();
    _exclamationAnimationController.dispose();
    _exclamationOptionsController.dispose();
  }

  // --- Componentes da Interface ---
  AppBar _buildAppBar(double screenWidth) {
    return AppBar(
      title: Row(
        children: [
          _buildMenuButton(),
          const SizedBox(width: 10),
          _buildAppTitle(screenWidth),
          const SizedBox(width: 10),
          _buildProfileImage(),
        ],
      ),
      elevation: 4,
      backgroundColor: Colors.orangeAccent,
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () => _showProfileMenu(),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person, color: Colors.black),
      ),
    );
  }

  void _showProfileMenu() {
    final authService = Provider.of<AuthService>(context, listen: false);

    final List<PopupMenuEntry<dynamic>> menuItems = [];

    // Adiciona opções com base no estado de autenticação
    if (authService.isAuthenticated) {
      menuItems.add(
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              authService.logout();
              Navigator.pop(context); // Fecha o menu após sair
            },
            child: const Text('Sair'),
          ),
        ),
      );
    } else {
      menuItems.add(
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              // Fecha o menu antes de navegar para a tela de login
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen(authService)),
              );
            },
            child: const Text('Fazer Login'),
          ),
        ),
      );
    }

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 65, 0, 0),
      items: menuItems,
    ).then((_) {
      if (_isExclamationOpen) {
        _toggleExclamationOptions();
      }
    });
  }

  IconButton _buildMenuButton() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return IconButton(
      icon: Icon(
        Icons.menu,
        color: themeProvider.isDarkTheme
            ? Colors.white
            : Colors.black, // Altera a cor com base no tema
      ),
      onPressed: _toggleMenu,
    );
  }

  Expanded _buildAppTitle(double screenWidth) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double fontSize;

            if (screenWidth < 600) {
              fontSize =
                  screenWidth * 0.05; // Tamanho proporcional para telas menores
            } else if (screenWidth < 720) {
              fontSize = 20; // Tamanho fixo para telas entre 600 e 720
            } else {
              fontSize = 20 +
                  (screenWidth - 720) *
                      (4.0 / 300); // Ajusta a mudança de tamanho
            }

            return Stack(
              alignment: Alignment.center,
              children: [
                // Texto com contorno preto
                Text(
                  'Minei - Supermercados',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    fontSize: fontSize,
                    color: Colors.black, // Cor do contorno
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0), // Offset para o contorno
                      ),
                    ],
                  ),
                ),
                // Texto preenchido em branco
                Text(
                  'Minei - Supermercados',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    fontSize: fontSize,
                    color: Colors.white, // Cor do preenchimento
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- Função que alterna o estado do menu ---
  void _toggleMenu() {
    if (_menuAnimationController.isCompleted) {
      _menuAnimationController.reverse();
    } else {
      _menuAnimationController.forward();
    }
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  // --- Corpo Principal da Tela ---
  Widget _buildBodyContent(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bem-vindo ao Minei!',
            style: themeProvider.isDarkTheme
                ? Theme.of(context).textTheme.headlineMedium
                : const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
          ),
          const SizedBox(height: 20),
          Text(
            'Compare preços e economize!',
            style: themeProvider.isDarkTheme
                ? Theme.of(context).textTheme.bodyMedium
                : const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
          ),
          const SizedBox(height: 20),
          Text(
            'É novo por aqui? Faça o Cadastro ou caso já seja de casa faça o Login.',
            style: themeProvider.isDarkTheme
                ? Theme.of(context).textTheme.bodySmall
                : const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          _buildLoginAndCadastroButtons(),
        ],
      ),
    );
  }

  Widget _buildShoppingList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Gerencie seu Perfil',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildProfileButton('Minha Lista de Compras',
              onTap: _navigateToShoppingList),
          const SizedBox(height: 10),
          _buildProfileButton('Amigos'),
          const SizedBox(height: 10),
          _buildProfileButton('Configurações',
              onTap: _showSettings), // Exibir configurações
          const SizedBox(height: 10),
          _buildProfileButton('Logout', onTap: _handleLogout),
        ],
      ),
    );
  }

  void _navigateToShoppingList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShoppingListScreen()),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Configurações'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tema Escuro'),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Switch(
                    value: themeProvider.isDarkTheme,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() {
    final authService = Provider.of<AuthService>(context, listen: false);

    // Executa a lógica de logout
    authService.logout();

    // Navega de volta para a tela inicial após o logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen()), // Redireciona para a HomeScreen
      (route) => false, // Remove todas as rotas anteriores
    );
  }

  Widget _buildProfileButton(String text, {VoidCallback? onTap}) {
    return SizedBox(
      width: 200, // Defina um tamanho fixo para todos os botões
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginAndCadastroButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CadastroScreen()),
            );
          },
          child: const Text(
            'Cadastro',
            style: TextStyle(color: Colors.orangeAccent, fontSize: 16),
          ),
        ),
        const Text(
          ' | ',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginScreen(
                      Provider.of<AuthService>(context, listen: false))),
            );
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.orangeAccent, fontSize: 16),
          ),
        ),
      ],
    );
  }

  // --- Menu Lateral ---
  Widget _buildSideMenu(double screenWidth) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return SlideTransition(
      position: _menuAnimationController.drive(
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: GestureDetector(
        onTap: () {
          // Impede o fechamento ao clicar dentro do menu
        },
        child: Container(
          width: screenWidth * 0.4,
          color: Colors.orangeAccent.withAlpha(200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Exibe o botão de login como um link clicável
              if (!authService.isAuthenticated)
                GestureDetector(
                  onTap: () async {
                    _menuAnimationController.reverse(); // Fechar o menu
                    await Future.delayed(const Duration(
                        milliseconds: 300)); // Aguardar o fechamento

                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(authService),
                        ),
                      );
                    }
                  },
                  child: _buildMenuOption('Login'),
                ),
              const SizedBox(height: 8),
              // Exibe as opções apenas se o usuário estiver autenticado
              if (authService.isAuthenticated) ...[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketsScreen(),
                      ),
                    );
                  },
                  child: _buildMenuOption('Mercados'),
                ),
                const SizedBox(height: 8),
                _buildMenuOption('Planos'),
                const SizedBox(height: 8),
                // Botão 'Suporte' agora redireciona para a tela de tutorial
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HelpScreen()), // Redireciona para a tela de tutorial
                    );
                  },
                  child: _buildMenuOption('Suporte'),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PriceComparisonScreen(),
                      ),
                    );
                  },
                  child: _buildMenuOption('Comparar Preços'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --- Botão de Exclamação ---
  Positioned _buildExclamationButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _exclamationAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _isExclamationOpen
                ? 1 + _exclamationAnimationController.value * 0.2
                : 1,
            child: FloatingActionButton(
              onPressed: _toggleExclamationOptions,
              backgroundColor: Colors.orangeAccent,
              elevation: 10,
              child: const Icon(Icons.warning_amber_rounded, size: 32),
            ),
          );
        },
      ),
    );
  }

  // --- Alterna o estado do botão de exclamação ---
  void _toggleExclamationOptions() {
    if (_isExclamationOpen) {
      // Animar a opção de saída
      _exclamationOptionsController.reverse().then((_) {
        setState(() {
          _isExclamationOpen = false; // Atualiza o estado após a animação
        });
      });
    } else {
      setState(() {
        _isExclamationOpen = true; // Atualiza o estado antes da animação
      });
      _exclamationOptionsController.forward();
    }

    if (_isExclamationOpen) {
      _exclamationAnimationController.forward();
    } else {
      _exclamationAnimationController.reverse();
    }
  }

  // --- Opções de Exclamação ---
  Positioned _buildExclamationOptions() {
    final authService =
        Provider.of<AuthService>(context); // Obtendo AuthService

    return Positioned(
      bottom: _isExclamationOpen ? 80 : 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _exclamationOptionsController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _exclamationOptionsController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Exibe a opção de informar alteração de preço apenas se o usuário estiver autenticado
                // Adicione a navegação para ChangePriceScreen
                if (authService.isAuthenticated)
                  GestureDetector(
                    onTap: () {
                      _toggleExclamationOptions(); // Fecha o menu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ChangePriceScreen(), // Navega para a tela de alteração de preço
                        ),
                      );
                    },
                    child: _buildAnimatedMenuOption(
                        'Informar alteração de preço', Colors.orangeAccent, 0),
                  ),
                GestureDetector(
                  onTap: () {
                    // Fecha as opções de exclamação antes de navegar
                    _toggleExclamationOptions(); // Fecha o menu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  },
                  child: _buildAnimatedMenuOption(
                      'Precisa de ajuda?', Colors.blue, 1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Função para criar opções de menu com animação ---
  Widget _buildAnimatedMenuOption(String text, Color color, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      child: _buildMenuOption(text, color),
    );
  }

  // --- Opção de Menu ---
  Widget _buildMenuOption(String text, [Color color = Colors.white]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --- Lida com o toque fora do menu ---
  void _handleTapOutsideMenus() {
    if (_menuAnimationController.isCompleted) {
      _menuAnimationController.reverse();
      setState(() {
        _isMenuOpen = false;
      });
    }
    if (_isExclamationOpen) {
      _exclamationOptionsController.reverse().then((_) {
        setState(() {
          _isExclamationOpen = false; // Atualiza o estado após a animação
        });
      });
      _exclamationAnimationController.reverse();
    }
  }
}
