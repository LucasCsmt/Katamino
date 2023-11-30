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

class GameState extends State<Game> {
  final Grid _g = Grid(5, 12);
  final Piece _L = Piece.lshape();

  void _addPiece(Piece p, StdCoords c) {
    setState(() {
      if (!_g.pieceAlreadyPlaced(p)) {
        _g.putPiece(p, c);
      }
    });
  }

  void _remove(Piece p) {
    setState(() {
      if (_g.pieceAlreadyPlaced(p)) {
        _g.removePiece(p);
      }
    });
  }

  void _rotate(Piece p) {
    setState(() {
      if (!_g.pieceAlreadyPlaced(p)) {
        _L.rotate();
      }
    });
  }

  Future<Widget> _renderGrid() async{
    return SizedBox(
      width : _g.getNbCols() * 50,
      height : _g.getNbRows() * 50,
      child : GridView.builder(
        itemCount : _g.getNbRows() * _g.getNbCols(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _g.getNbCols(),
        ),
        itemBuilder: (BuildContext context, int index){
          int i = index ~/ _g.getNbCols();
          int j = index % _g.getNbCols();
          return DragTarget<Piece>( 
            builder: (context, candidateData, rejectedData){
              return ColoredBox(
                color: (_g.get(i, j) == -1) ? (candidateData.isEmpty) ? Colors.white : (_g.isValid(candidateData[0] as Piece, StdCoords.fromInt(i, j))) ? Colors.grey : Colors.red : Piece.colors[_g.get(i, j)],
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Text(_g.get(i, j).toString()),
                )
              );
            },
            onWillAccept: (data){
              if(data.runtimeType == Null){
                return false;
              }
              return _g.isValid(data as Piece, StdCoords.fromList([i, j]));
            },
            onAccept: (data){
              print("Accepté : ${data.getPath().getCoordsList()}");
              _addPiece(data, StdCoords.fromInt(i, j));
            }
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future : _renderGrid(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColoredBox(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ),
                  ColoredBox(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: SizedBox(
                        width: _g.getNbCols() * 50.0,
                        child: snapshot.data as Widget,
                      ),
                    ),
                  ),
                  FloatingActionButton(onPressed: (){
                    _remove(_L);
                  },
                  child: Icon(Icons.remove)),
                  FloatingActionButton(onPressed: (){
                    _rotate(_L);
                  },
                  child: Icon(Icons.arrow_back),),
                  ColoredBox(
                    color : Colors.blue,
                    child: _L.getWidget(),
                  ),

                ],
              )
            );
          } else {
            return Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            );
          }
        }
      ),
    );
  }
}