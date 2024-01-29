import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/accueil.dart';
import 'pages/gamemode_menu.dart';
import 'pages/regles.dart';
import 'pages/level.dart';
import 'widget/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(MainApp());
    });
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => Accueil(),
          '/gamemodeMenu': (context) => GameModeMenu(),
          '/level': (context) => Level(),
          '/regles' : (context) => Regles(),
          '/endless' : (context) => Game(),
        },
        debugShowCheckedModeBanner: false,
      );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                const SecondPage(),
              transitionsBuilder : ((context, animation, secondaryAnimation, child) => 
                FadeTransition(opacity: animation, child: child)
            )));
          },
          child : const Text("Go to Second Page"),
        )
      )
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/");
          },
          child : const Text("Go to First Page"),
        )
      )
    );
  }
}