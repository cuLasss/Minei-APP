import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'database.dart';
import 'home_screen.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthService(Database())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessando o ThemeProvider para aplicar o tema correto
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkTheme
          ? ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.orangeAccent,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.orangeAccent),
                elevation: 4,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white70),
                headlineMedium: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.orangeAccent,
                textTheme: ButtonTextTheme.primary,
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.orangeAccent,
              ),
            )
          : ThemeData(
              primarySwatch: Colors.orange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.orangeAccent,
              ),
            ),
      home: const HomeScreen(),
    );
  }
}
