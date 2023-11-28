import 'package:flutter/material.dart';
import 'model/piece.dart';

void main() {
  runApp(const MainApp());
  const p = PieceType.lshape;
  print(p.getCenter());
  print(p.getPath().getPathLength());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
