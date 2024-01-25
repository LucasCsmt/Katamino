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

class Score {
  late final int _score;

  //on met en valeur de base le temps actuel à l'instanciation
  late final int _time;
  
  //construteur
  Score(int scoreMax){
    _time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    _score = scoreMax;
  }

  int getScore(){
    //on calcule le score par rapport au temps qui s'est écoulé
    int newTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return _score + (_time - newTime);
  }

}
class GameState extends State<Game> {
  GlobalKey key = GlobalKey();
  final List<Piece> _pieces = [
    Piece.lshape(), 
    Piece.ushape(),
    Piece.nshape(),
    Piece.zshape(),
    Piece.tshape(),
    Piece.vshape(),
    Piece.ishape(),
    Piece.wshape(),
    Piece.xshape(),
    Piece.yshape(),
    Piece.fshape(),
    Piece.pshape()];
  late final Grid _g;
  Map<Piece,List<MutableOffset>> _offsetmap = Map();
  Map<Piece, List<MutableOffset>> _baseOffsetMap = Map();
  Offset _feedbackOffset = Offset.zero;
  Piece? _currPiece = null;
  Score _score = Score(100);
  int squareSize = 50;
  
  void initOffsetPiece(Piece piece, Offset baseOffset){
    final entry = <Piece,List<MutableOffset>>{piece : <MutableOffset>[]};
    final entry2 = <Piece,List<MutableOffset>>{piece : <MutableOffset>[]};
    for(StdCoords c in piece.getPath().getCoordsList()) {
      entry[piece]?.add(MutableOffset(Offset(c.getYCoords() * squareSize + baseOffset.dx, c.getXCoords() * squareSize + baseOffset.dy)));
      entry2[piece]?.add(MutableOffset(Offset(c.getYCoords() * squareSize + baseOffset.dx, c.getXCoords() * squareSize + baseOffset.dy)));
    }
    print("init");
    _offsetmap.addEntries(entry.entries);
    _baseOffsetMap.addEntries(entry2.entries);
  }
  
  @override
  void initState() {
    super.initState();
    _g = Grid(_pieces.length, 5);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("height : ${height}");
    double grid_height  = height * (30/100);
    print("grid_height : ${grid_height}");
    squareSize = ((grid_height / _pieces.length)).toInt();
    print("squareSize:${squareSize}"); 
    /* print("1");
    if(key == Null){
      print("key is null");
    }
    else{
      print("key is not null");
    }
    RenderBox box = key.currentContext?.findRenderObject()! as RenderBox;
    print("2");
    Offset position = box.localToGlobal(Offset.zero);
    print("3");
    double height_grid = (position.dy +_g.getNbRows() * squareSize.0) - position.dy;
    double free_height = height - height_grid; */
    
    if(_pieces.length > 6){
      double incr = _pieces.length % 2 == 0 ? (width / _pieces.length) * 3 : (width / (_pieces.length + 1)) * 3;
      
      print("le fdp au dessus de moi c'est jhin?");
      print("width / 8 : ${width / 8}");
      print("incr $incr");
      print("width $width");
      Offset baseOffset = Offset(squareSize.toDouble() + squareSize * 5, height - ((squareSize * 5).toDouble() +  height * (10/100)));

      int i = 0;
      // size of the window 
      for (Piece piece in _pieces) {
        print("i : ${i}");  
        print(baseOffset);
        baseOffset = i == _pieces.length ~/ 3 ? Offset(squareSize.toDouble() + squareSize * 5, baseOffset.dy - squareSize * 4) : baseOffset;
        baseOffset = i == _pieces.length ~/ 3 * 2 ? Offset(squareSize.toDouble() + squareSize * 5, baseOffset.dy - squareSize * 4) : baseOffset;
        print("y: ${baseOffset.dy}");
        initOffsetPiece(piece, Offset(baseOffset.dx, baseOffset.dy));
        baseOffset = Offset(baseOffset.dx + incr, baseOffset.dy);
        i++;
      }
    }
    else {
      double incr = width / _pieces.length;
      Offset baseOffset = Offset(squareSize.toDouble(), height - ((squareSize * 5).toDouble() + squareSize / 2));

      // size of the window 
      for (Piece piece in _pieces) {
        initOffsetPiece(piece, baseOffset);
        baseOffset = Offset(baseOffset.dx + incr, baseOffset.dy );
      }
    }
    
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
      return SizedBox(
          key : key,
          width : _g.getNbCols() * squareSize.toDouble(),
          height : _g.getNbRows() * squareSize.toDouble(),
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
                      width: squareSize.toDouble(),
                      height: squareSize.toDouble(),
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
                                  
                }
              );
            },
          ),
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
                          width: _g.getNbCols() * squareSize.toDouble(),
                          child: snapshot.data as Widget,
                        ),
                      ),
                    ),
                    FloatingActionButton(onPressed: (){
                      if(_currPiece != null && !_g.pieceAlreadyPlaced(_currPiece!)){
                        _rotate(_currPiece!);
                      }   
                    },
                    child : const Icon(Icons.arrow_back)),
                    FloatingActionButton(onPressed: (){
                      if(_currPiece != null && !_g.pieceAlreadyPlaced(_currPiece!)){
                        _flip(_currPiece!);
                      }
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

  int nbPiecePlaced(){
    int ret = 0;
    for(Piece p in _pieces){
      if(_g.pieceAlreadyPlaced(p)){
        ret++;
      }
    }
    return ret;
  }

  bool checkWinCondition(){
    return _g.getNbCols() == nbPiecePlaced();
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> children = createChildren(_pieces);
    children.addAll(createDraggablePieces());
    if(checkWinCondition()){
        print("c'est la win");
        //on return le widget de la win
        Offset position = (key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
        children.addAll(
            [
             Positioned(
              left: position.dx + squareSize,
              top: position.dy + squareSize,
              child :
                ColoredBox(
                  color: Colors.blue,
                  child: SizedBox(
                          width: _g.getNbCols() * squareSize.toDouble(),
                          height: _g.getNbRows() * squareSize.toDouble(),
                          child: 
                            Text("Vous avez gagné !\nVotre score est de : ${_score.getScore()} points !",
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            )
                        ),
                 ),
              ),
              //on ajoute le bouton de reset
              Positioned(
                left: position.dx + squareSize,
                top: position.dy + squareSize + _g.getNbRows() * squareSize,
                child :
                  FloatingActionButton(
                    onPressed: (){
                      setState(() {
                        _g.reset();
                        initState();
                      }); 
                    },
                    child: const Icon(Icons.refresh),
                  ) 
              )
            ]
          )
        ;
    }
    return Stack(
        children : children
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
      for(MutableOffset off in _offsetmap[p]!){
        ret.add(
          Positioned(
          left: off.getOffset().dx,
          top: off.getOffset().dy,
          child : Draggable<Piece>(
              data: p,             
              feedbackOffset: _feedbackOffset,
              feedback: CustomPaint(
                size: Size((5 * squareSize).toDouble() , (5 * squareSize).toDouble()),
                painter: PiecePainter.good(p, Colors.grey, _offsetmap[p]!, off),
              ),
              onDragStarted: () {
                _currPiece = p;
                _remove(p, Offset(0,0));
              },
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  print("-------GET CANCERED--------");
                  print("avant...");
                  int i = 0;
                  for (MutableOffset o in _offsetmap[p]!) {
                    o.setOffset(_baseOffsetMap[p]![i].getOffset());
                    i++;
                  }
                  print("APRES !!!");
                  
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
                  
                  Offset ret = Offset(position.dx + (x * squareSize) + sub.dx, position.dy + (y * squareSize) + sub.dy);
                  updateOffsetPiece(off, _offsetmap[p]!, ret);
                });
              } ,
              
              child: Container(
                  width: squareSize.toDouble(),
                  height: squareSize.toDouble(),
                  decoration: 
                  BoxDecoration(
                    border: Border.all(
                      color: p.getColor(),
                      width: 0.5,
                    ),
                    color: p.getColor(),
                  ),
              ),    
            ) 
          )
        );
      }
    }
    return ret;
  }
}
