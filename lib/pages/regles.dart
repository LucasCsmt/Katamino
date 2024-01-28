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
      body : Center (
        child : Text("Insert rules here")
      )
    );
  }
}