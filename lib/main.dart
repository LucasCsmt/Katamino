import 'package:flutter/material.dart';

import 'model/piece.dart';
import 'model/grid.dart';
import 'widget/game.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katamino',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 59, 7, 68)),
        useMaterial3:  true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Game(title: 'Katamino v1.0.0'),
    );
  }
}

