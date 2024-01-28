import 'package:flutter/material.dart';

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {

    ElevatedButton createButton(String text, String route, Color primaryColor, Color textColor){
      return ElevatedButton(
        style: ButtonStyle( 
          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
        ),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text, style: TextStyle(fontSize: 20)),
        ),
      );
    }

    ElevatedButton createMainElevatedButton(String text, String route){
      return createButton(text, route, Color.fromARGB(255, 58, 12, 163), Colors.white);
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
        children: [
          Expanded(
            child: Center(
              child: Text( 
                "Katamino",
                style: TextStyle( 
                  fontSize: 50, 
                  fontWeight: FontWeight.bold,
                )
              )
            ),
          ),
          Expanded(
            child: Center( 
              child : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  createMainElevatedButton("Jouer", "/gamemodeMenu"),
                  createMainElevatedButton("Règles", "/regles"),
                ],
              )
            ),
          ),
        ],
      )
    );
  }
}
