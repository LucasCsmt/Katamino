import 'dart:math';

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

class MutableOffset {
  Offset _offset = Offset(0,0);

  MutableOffset(Offset off){
    _offset = off;
  }

  Offset getOffset(){
    return _offset;
  }

  void setOffset(Offset newOff){
    _offset = newOff;
  }
}

class GameState extends State<Game> {
  GlobalKey key = GlobalKey();
  final List<Piece> _pieces = [
    Piece.lshape(), 
    Piece.ushape(),
    Piece.fshape(),
    Piece.ishape(),
    Piece.nshape(),
    Piece.pshape(),
    Piece.tshape(),
    Piece.vshape(),
    Piece.wshape(),
    Piece.xshape(),
    Piece.yshape(),
    Piece.zshape()];
  final Grid _g = Grid(5, 5);
  Map<Piece,List<MutableOffset>> _offsetmap = Map();
  Offset _feedbackOffset = Offset.zero;

  void initOffsetPiece(Piece piece){
    final entry = <Piece,List<MutableOffset>>{piece : <MutableOffset>[]};
    for(StdCoords c in piece.getPath().getCoordsList()){
      entry[piece]?.add(MutableOffset(Offset(c.getYCoords() * 50, c.getXCoords() * 50)));
    }
    _offsetmap.addEntries(entry.entries);
  }
  
  @override
  void initState() {
    for(Piece piece in _pieces){
      initOffsetPiece(piece);
    }
    super.initState();
  }
  
  void _addPiece(Piece p, StdCoords c) {
    setState(() {
      if (!_g.pieceAlreadyPlaced(p)) {
        _g.putPiece(p, c);
      }
    });
  }

  void _remove(Piece p, Offset baseOffset) {
    setState(() {
      if (_g.pieceAlreadyPlaced(p)) {
        _g.removePiece(p);
      }
    });
    
  }

  void _rotate(Piece p) {
    setState(() {
      Offset c = _offsetmap[p]![p.getCoordC()].getOffset();
      for (MutableOffset o in _offsetmap[p]!) {
        o.setOffset(Offset(o.getOffset().dy, -o.getOffset().dx));
      }
      updateOffsetPiece(_offsetmap[p]![p.getCoordC()], _offsetmap[p]!, c);
      p.rotate();
      print(p.getPath().getCoordsList().toString());
    });
  }
  
  void _flip(Piece p) {
    setState(() {
      Offset c = _offsetmap[p]![p.getCoordC()].getOffset();
      for (MutableOffset o in _offsetmap[p]!) {
        o.setOffset(Offset(-o.getOffset().dx, o.getOffset().dy));
      }
      updateOffsetPiece(_offsetmap[p]![p.getCoordC()], _offsetmap[p]!, c);
      p.flip();
    });
  }

  Future<Widget> _renderGrid() async{
    return Positioned(
          key: key,
          left: 500,
          top: 500,
          child : SizedBox(
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
                      color: (_g.get(i, j) == -1) ? (candidateData.isEmpty) ? Colors.white :
                      (_g.isValid(candidateData[0] as Piece, StdCoords.fromInt(i, j))) ? Colors.grey : Colors.red : Piece.colors[_g.get(i, j)],
                      child: 
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
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
                    _addPiece(data as Piece, StdCoords.fromInt(i, j));                   
                    RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
                    Offset position = box.localToGlobal(Offset.zero); //this is global position                 
                  }
                );
              },
            ),
          )
    );
  }

  List<Widget> createChildren(List<Piece> pieces){
    List<Widget> children = [Scaffold(
        body: FutureBuilder(
          future : _renderGrid(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return Center(
                child: Column(
                  children: [
                    ColoredBox(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
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
                    /* FloatingActionButton(onPressed: (){
                      _remove(_L);
                    },
                    child: const Icon(Icons.remove)), */
                    FloatingActionButton(onPressed: (){
                      for (Piece p in _pieces) {
                        _rotate(p);
                      }
                    },
                    child : const Icon(Icons.arrow_back)),
                    FloatingActionButton(onPressed: (){
                        _flip(_pieces[0]);
                    },
                    child: const Icon(Icons.flip),),
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
      ),   
    ];
    return children;
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> _children = createChildren(_pieces);
    _children.addAll(createDraggablePieces());
    return Stack(
      children : _children
    );
  }

  void updateOffsetPiece(MutableOffset off, List<MutableOffset> lf, Offset newOff){
    for(MutableOffset o in lf){
      if(o != off){
        o.setOffset(newOff + (o.getOffset() - off.getOffset()));
      }
    }
    off.setOffset(newOff);
  }

  List<Widget> createDraggablePieces(){
    List<Widget> ret = [];
    for(Piece p in _pieces){
      int i = 0;
      for(MutableOffset off in _offsetmap[p]!){
        i++;
        print("on cree des draggable là");
        ret.add(
          Positioned(
          left: off.getOffset().dx,
          top: off.getOffset().dy,
          child : Draggable<Piece>(
              data: p,             
              feedbackOffset: _feedbackOffset,
              feedback: CustomPaint(
                size: Size(250, 250),
                painter: PiecePainter.good(p, Colors.grey, _offsetmap[p]!, off),
              ),
              onDragStarted: () {
                _remove(p, Offset(0,0));
              },
              onDragEnd: (details) {
                setState(() {
                  updateOffsetPiece(off, _offsetmap[p]!, details.offset);

                });
              },  
              onDragCompleted: () {
                setState(() {
                  RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
                  Offset position = box.localToGlobal(Offset.zero);
                  StdCoords c = _g.getCoordsOfPiece(p);
                  int x = c.getYCoords();
                  int y = c.getXCoords();
                
                  Offset sub = off.getOffset() - _offsetmap[p]![p.getCoordC()].getOffset();
                  
                  Offset ret = Offset(position.dx + (x * 50) + sub.dx, position.dy + (y * 50) + sub.dy);
                  print(ret);
                  updateOffsetPiece(off, _offsetmap[p]!, ret);
                  

                });
              } ,
              
              child: Container(
                  width: 50,
                  height: 50,
                  color: p.getColor(),
                  child: Text("$i"),
              ),    
            ) 
          )
        );
      }
    }
    return ret;
  }
}