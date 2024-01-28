import 'package:flutter/material.dart';

class Level extends StatelessWidget {
  const Level({super.key});

  Widget levelWidget(String level, BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion( 
        cursor: SystemMouseCursors.click,
        child: GestureDetector( 
          onTap : () {
            Navigator.pushNamed(context, "/");
          },
          child: Container( 
            width : 100,
            height : 100,
            decoration : BoxDecoration( 
              color : Colors.blue,
              borderRadius : BorderRadius.circular(10),
            ),
            child : Padding( 
              padding : const EdgeInsets.all(8.0),
              child : Center(
                child: Text( 
                  level,
                  style : TextStyle( 
                    color : Colors.white,
                    fontSize : 20,
                  )
                ),
              )
            )
          )
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title : 
          Text("Level mode", 
            style : TextStyle( 
              color: Colors.white
            )
          ),
        backgroundColor : Color.fromARGB(255, 67, 97, 238),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: 
        Center ( 
          child: 
            Column( 
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ 
                Text("Niveau 1", 
                  style: 
                    TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: 
                    TextAlign.left),
                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    shrinkWrap: true,
                    children: [
                      levelWidget("1 - a", context),
                      levelWidget("1 - b", context),
                      levelWidget("1 - c", context),
                      levelWidget("1 - d", context),
                      levelWidget("1 - e", context),
                    ],
                  ),
                ),
              ],
            )
        ),
    );
  }
}