import 'package:flutter/material.dart';

class Regles extends StatelessWidget {
  const Regles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        title : 
          Text("Règles", 
            style : TextStyle( 
              color: Colors.white
            )
        ),
        backgroundColor : Color.fromARGB(255, 67, 97, 238),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body : const Center (
        child: ColoredBox(
          color: Colors.tealAccent,
          child : Text("Katamino est un jeu de société où les joueurs disposent des pentaminos\n"
                       "(formes géométriques composées de cinq carrés) pour les faire tenir\n"
                       "dans un plateau rectangulaire. L'objectif est de remplir l'ensemble\n" 
                       "du plateau en utilisant un nombre spécifique de pièces, \n"
                       "déterminé par la carte de puzzle choisie. Chaque pièce doit être utilisée,\n"
                       " et elles ne peuvent pas se chevaucher ni dépasser les limites du plateau.\n"
                       "Le défi consiste à trouver la combinaison et l'orientation correctes \n"
                       "des pentaminos pour résoudre chaque puzzle dans les contraintes données,\n" 
                       "nécessitant une réflexion spatiale et un placement stratégique.",
          textAlign: TextAlign.justify,)
      ))
    );
  }
}