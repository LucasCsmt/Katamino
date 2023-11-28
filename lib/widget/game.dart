import '../model/piece.dart';
import '../util/std_coords.dart';
import '../model/grid.dart';
import 'package:flutter/material.dart';


class Game extends StatefulWidget {
  final String title;
  
  const Game({super.key, required this.title});
  
  @override
  State<Game> createState() => GameState();
}   

class GameState extends State<Game>  {
  final Grid _g = Grid(12, 5);
  final Piece _L = Piece.ushape();

  void _addPiece(){
    setState(() {
      if(!_g.pieceAlreadyPlaced(_L)){
        _g.putPiece(_L, StdCoords.fromList([2,-1]));
      }
    });
  }

  void _rotate(){
    setState(() {
      _remove();
      _L.rotate();
      _addPiece();
    });
  }

  void _remove(){
    setState(() {
      if(_g.pieceAlreadyPlaced(_L)){
        _g.removePiece(_L);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Container(
            child:  SizedBox(
              width : 200,
              height : 1000,
              child: _g.renderGrid()),
          ),
        ),
        floatingActionButton: Column(
          children: [
            FloatingActionButton(onPressed: _rotate, 
              tooltip: "rotate", 
              backgroundColor: Theme.of(context).colorScheme.inversePrimary, 
              child: const Icon(Icons.rotate_left),),
            FloatingActionButton(onPressed: _remove, 
              tooltip: "remove", 
              backgroundColor: Theme.of(context).colorScheme.inversePrimary, 
              child: const Icon(Icons.remove_circle),),
            FloatingActionButton(
              onPressed: _addPiece,
              tooltip: 'putPiece',
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      );
  }  
}