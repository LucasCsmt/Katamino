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
  final Piece _L = Piece.lshape();
  final List<Piece> _pieces = [Piece.lshape(), Piece.ushape()];
  final Grid _g = Grid(5, 12);
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
    int maxX = 1920;
    double i = 0;
    for (Piece p in _pieces) {
      p.setOffset(Offset((maxX / _pieces.length) * i, 1000));
      i++;
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
/*         p.setOffset(Offset (p.getCenter().getXCoords() * 50, p.getCenter().getYCoords() * 50));
 */        p.setOffset(baseOffset); 
        }
    });
  }

  void _rotate(Piece p) {
    setState(() {
      if (!_g.pieceAlreadyPlaced(p)) {
        p.rotate();
      }
    });
  }

  void _flip(Piece p) {
    setState(() {
      if (!_g.pieceAlreadyPlaced(p)) {
        p.flip();
      }
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
                            width: 1,
                          ),
                        ),
                        child: Text("$i,$j"),//Text(_g.get(i, j).toString()),
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
                    // Affiche les coordonnées de la case où on a déposé la pièce
                    // Get la position globale de la case au centre = la souris
                    print(_offsetmap[data as Piece]?[1].getOffset());
                    // Get la position globale de la case target
                    //// Get la position globale de la grille
                    

                    // 60% CT Le jeu (placement des pièces, rotation, flip, etc...)
                    // -- Implémentation des pièces (formes, couleurs, etc...) [x]
                    // -- Implémentation de la grille [x]
                    // -- Implémentation d'un placement correct des pièces sur la grille [~]
                    // -- Implémentation des rotations / flips des pièces []
                    // -- Implémentation d'un système de deck []
                    // -- Implémentation des différents modes de jeux []
                    // -- Implémentation d'un système de scoring []
                    // -- Implémentation d'un système de sauvegarde []


                    // 20% CT Menu - navigation
                    // -- Menu principal []
                    // -- Menu des paramètres []
                    // -- Menu de sélection des modes de jeux []
                    // -- Menu de sélection des niveaux []
                    // -- Menu de chargement entre les pages []

                    // Du flanc (très bon flanc) : Design, esthétique, UI/UX
                    // -- Palettes de couleur []
                    // -- Design des pièces 

                    // 10% CT Niveaux et système de scoring (fair) theorycraft des modes de jeux
                    
                    RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
                    Offset position = box.localToGlobal(Offset.zero); //this is global position
                    //// Calculer la position globale de la case en fonction de la position de la grille
                    print("Offset target : " + Offset(i * 50 + position.dx, j * 50 + position.dy).toString());
                    // Faire la différence
                    print("onaccept");
                    
                  }
                );
              },
            ),
          )
    );
  }

  Widget _positionedPiece(Piece p, Offset baseOffset) {
    Offset temp_offset = p.getOffset();
    return Positioned(
        left: p.getOffset().dx,
        top: p.getOffset().dy,
        child: Visibility(
          visible: !_g.pieceAlreadyPlaced(p),
          maintainSize: true,
          maintainState: true,
          maintainAnimation: true,
          maintainInteractivity: true,
          child: Draggable<Piece>(
          data: p,
          dragAnchorStrategy: p.centerDragAnchorStrategy,
          child: Container(
            child: CustomPaint(
                size: Size(250, 250),
                painter: PiecePainter(p, Colors.red),
            ),
          ),
          feedback: Container(
              child: CustomPaint(
                size: Size(250, 250),
                painter: PiecePainter(p, Colors.grey),
              ),
          ),
          childWhenDragging: Container(
            child: CustomPaint(
                size: Size(250, 250),
                painter: PiecePainter(p, Colors.green),
              ),
            ),

          onDragStarted: () {
            if(_g.pieceAlreadyPlaced(p)){
              _remove(p, baseOffset);
            }

          },
          /* onDraggableCanceled: (velocity, offset) {
            p.setOffset(baseOffset);
          }, */
          onDragEnd: (details) {
            setState(() {
              if (_g.pieceAlreadyPlaced(p)) {
                p.setOffset(details.offset);
              } else {
                p.setOffset(baseOffset);
              }
            });
            
            /* temp_offset = details.offset;
            print("end");
            print(details.offset);
            print(temp_offset); */
          },
          /* onDragCompleted: () {
            p.setOffset(temp_offset); 
            print("nouveau");
            print(temp_offset);
          }, */
          )), 
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
                      _rotate(_L);
                    },
                    child : const Icon(Icons.arrow_back)),
                    FloatingActionButton(onPressed: (){
                      _flip(_L);
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
    int maxX = 1920;
    double i = 0;
    for(Piece p in pieces){
      children.add(_positionedPiece(p, Offset((maxX / pieces.length) * i, 1000)));
      i++;
    }
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
    off = lf[1];
    for(MutableOffset o in lf){
      if(o != off){
        o.setOffset(newOff + (o.getOffset() - off.getOffset()));
      }
    }
    off.setOffset(newOff);
  }


  List<Widget> createDraggablePieces(){
    List<Widget> ret = [];
      print("---------Game---------");
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
                size: Size(250, 250),
                painter: PiecePainter.good(p, Colors.grey, _offsetmap[p]!, off),
              ),
              onDragStarted: () {
                _remove(p, Offset(0,0));
              },
              onDragEnd: (details) {
                print("dragend");
                setState(() {
                  updateOffsetPiece(off, _offsetmap[p]!, details.offset);
                });
              },  
              onDragCompleted: () {
                setState(() {
                  RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
                  Offset position = box.localToGlobal(Offset.zero);
                  print("position $position");
                  Offset o = position;
                  // for(double x = position.dx; x < position.dx - 50 * 12; x - 50){
                  //   print("x $x");
                  //   for(double y = position.dy; y < position.dy - 50 * 5; y - 50){
                  //     print("y $y");
                  //     if(off.getOffset().dx >= x && off.getOffset().dx < x - 50 && off.getOffset().dy >= y && off.getOffset().dy < y - 50){
                  //       o = Offset(x, y);
                  //     }
                  //   }
                  // }
                  Offset ox = Offset(off.getOffset().dx - position.dx, off.getOffset().dy - position.dy);
                  print("ox $ox");
                
                  int x;
                  int y;
                  if(ox.dx % 50 >= 25){
                    if(ox.dy % 50 >= 25){
                      print("1");
                      x = (ox.dx / 50).floor() + 1;
                      y = (ox.dy / 50).floor();
                    }
                    else {
                      print("2");
                      x = (ox.dx / 50).floor() + 1;
                      y = (ox.dy / 50).floor();
                    }
                  }
                  else{
                    if (ox.dy % 50 >= 25){
                      print("3");
                      x = (ox.dx / 50).floor();
                      y = (ox.dy / 50).floor() + 1;
                    }
                    else {
                      print("4");
                      x = (ox.dx / 50).floor();
                      y = (ox.dy / 50).floor();
                    }
                  }
                  print("x $x");
                  print("y $y");
                  Offset center = _offsetmap[p]![p.getCoordC()].getOffset();
                  Offset sub = off.getOffset() - center;
                  print("sub $sub");
                  Offset ret = Offset(position.dx + (x * 50) - sub.dx, position.dy + (y * 50) - sub.dy);
                  print("ret $ret");
                  updateOffsetPiece(off, _offsetmap[p]!, ret);

                });
              } ,
              
              child: Container(
                  width: 50,
                  height: 50,
                  color: p.getColor(),
              ),    
            ) 
          )
        );
      }
    }
    return ret;
  }
}
/* List<Widget> test(p) {  

  return [
    Positioned(
      left: offset1.getOffset().dx,
      top: offset1.getOffset().dy,
      child : Draggable<Piece>(
            feedback: Container(
                width: 50,
                height: 50,
                color: Colors.purple,
            ),
            onDragEnd: (details) {
              setState(() {
                updateOffsetPiece(offset1, lf, details.offset);
              });
            },  
            child: Container(
                width: 50,
                height: 50,
                color: Colors.pink,
            ),    
      )
    ),
    Positioned(
      left: offset2.getOffset().dx,
      top: offset2.getOffset().dy,
      child : Draggable<Piece>(
            feedback: Container(
                width: 50,
                height: 50,
                color: Colors.purple,
            ),
            onDragEnd: (details) {
              setState(() {
                updateOffsetPiece(offset2, lf, details.offset);
              });
            },  
            child: Container(
                width: 50,
                height: 50,
                color: Colors.pink,
            ),    
      )
    ),
    Positioned(
      left: offset3.getOffset().dx,
      top: offset3.getOffset().dy,
      child : Draggable<Piece>(
            feedback: Container(
                width: 50,
                height: 50,
                color: Colors.purple,
            ),
            onDragEnd: (details) {
              setState(() {
                updateOffsetPiece(offset3, lf, details.offset);
              });
            },  
            child: Container(
                width: 50,
                height: 50,
                color: Colors.pink,
            ),    
      )
    ),
    Positioned(
      left: offset4.getOffset().dx,
      top: offset4.getOffset().dy,
      child : Draggable<Piece>(
            feedback: Container(
                width: 50,
                height: 50,
                color: Colors.purple,
            ),
            onDragEnd: (details) {
              setState(() {
                updateOffsetPiece(offset4, lf, details.offset);
              });
            },  
            child: Container(
                width: 50,
                height: 50,
                color: Colors.pink,
            ),    
      )
    ),
    Positioned(
      left: offset5.getOffset().dx,
      top: offset5.getOffset().dy,
      child : Draggable<Piece>(
            feedback: Container(
                width: 50,
                height: 50,
                color: Colors.purple,
            ),
            onDragEnd: (details) {
              setState(() {
                updateOffsetPiece(offset5, lf, details.offset);
              });
            },  
            child: Container(
                width: 50,
                height: 50,
                color: Colors.pink,
            ),    
      )
    ),
    ];
}  */

