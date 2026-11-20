
import 'package:flutter/material.dart';

import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'utils/tema_global.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: temaGlobal,
      builder: (context, tema, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Leitor e Editor de Documentos',

          theme: ThemeData(
            brightness: Brightness.light,
            colorSchemeSeed: Colors.deepPurple,
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.deepPurple,
            useMaterial3: true,
          ),

          themeMode: tema == 'Escuro'
              ? ThemeMode.dark
              : ThemeMode.light,

          initialRoute: '/',

          routes: {
            '/': (context) => const LoginView(),
            '/cadastro': (context) => const CadastroView(),
            '/home': (context) => const HomeView(),
          },
        );
      },
    );
  }
}
