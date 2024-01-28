import 'package:flutter/material.dart';

class GameModeMenu extends StatelessWidget {
  const GameModeMenu({super.key});
  
  Widget gameModeWidget(String mode, String description, BuildContext context, String route) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                mode,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title : 
          Text("Mode de jeu", 
            style: TextStyle( 
              color: Colors.white
            )
          ),
        backgroundColor: Color.fromARGB(255, 67, 97, 238),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center ( 
        child :
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              gameModeWidget("Level mode", "Les niveaux classiques du Katamino", context, "/level"),
              gameModeWidget("Endless mode", "Un mode de jeu infini", context, "/endless"),
              gameModeWidget("Multiplayer", "Pour jouer avec des amis !", context, "/"),
            ],
          )
      )
    );
  }
}