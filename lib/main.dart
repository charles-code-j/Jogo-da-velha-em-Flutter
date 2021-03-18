import 'package:flutter/material.dart';
import 'package:trabalho_jogo_da_velha_flutter/page/jogo_da_velha_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da velha',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: JogoDaVelhaPage(),
    );
  }
}
