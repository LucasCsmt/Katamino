
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
  Offset _offset = const Offset(0,0);

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
    Piece.nshape(),
    Piece.ishape(),
    Piece.vshape(),
    Piece.fshape(),
    Piece.tshape(),
    Piece.ushape(),
    Piece.wshape(),
    Piece.xshape(),
    Piece.yshape(),
    Piece.pshape(),
    Piece.zshape(),
  ];
  late final Grid _g;
  final Map<Piece,List<MutableOffset>> _offsetmap = {};
  final Map<Piece, List<MutableOffset>> _baseOffsetMap = {};
  final Offset _feedbackOffset = Offset.zero;
  Piece? _currPiece;
  final Score _score = Score(100);
  int squareSize = 0;
  
  void initOffsetPiece(Piece piece, Offset baseOffset){
    final entry = <Piece,List<MutableOffset>>{piece : <MutableOffset>[]};
    final entry2 = <Piece,List<MutableOffset>>{piece : <MutableOffset>[]};
    for(StdCoords c in piece.getPath().getCoordsList()) {
      entry[piece]?.add(MutableOffset(Offset(c.getYCoords() * squareSize + baseOffset.dx, c.getXCoords() * squareSize + baseOffset.dy)));
      entry2[piece]?.add(MutableOffset(Offset(c.getYCoords() * squareSize + baseOffset.dx, c.getXCoords() * squareSize + baseOffset.dy)));
    }
    _offsetmap.addEntries(entry.entries);
    _baseOffsetMap.addEntries(entry2.entries);
  }
  
  @override
  void initState() {
    _g = Grid(_pieces.length, 5);  
    //on initialise la taille de la fenetre de l'appli
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    {// Yo la team c'est Lucas.T si vous captez-pas trop lisez les commentaires ci-dessous:
     //Ceci est le bloc d'initialisation du placements des pièces dans le deck
     //l'algorithme est créer avec une résolution de téléphone en tête 
     //notamment du (9:19.5) comme sur les téléphones récents 
     //(exemple: iPhone 15 Pro Max avec 430 x 932 de résolution)
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      //la ligne suivante est un calcul de la hauteur optimal de la grille selon le nombre de pièces pour un écran en (9:19.5)
      //dans le meilleur des cas la hauteur de la grille fait 25%, 30% ou bien 35% de la hauteur de l'écran
      //ce cas n'arrivera presque jamais car le meilleur des cas est illusoire et la vie est faite d'imprévus
      double gridHeight  = _pieces.length <= 8 ? height * (25/100) : (_pieces.length <= 10 ? height * (30/100) : height * (35/100));
      double freeHeight = height * 0.9 - gridHeight;
      //on initialise la taille des carrés en fonction de la taille de la grille
      squareSize = gridHeight ~/ (_pieces.length);
      int nbPieceOnLine = (width) ~/ (squareSize * 5.1);
      int nbMaxLines = freeHeight ~/ (squareSize * 5.1);
      if(nbMaxLines == 0){
        nbMaxLines = 1;
      }
      while(nbMaxLines * nbPieceOnLine < _pieces.length ){
        //Tant que les carrés sont trop gros(no fat-shaming) pour rentrer dans la zone du deck on décrémente leur taille
        squareSize -= 1;//un carré qui maigris en faisant du sport
        nbPieceOnLine = (width) ~/ (squareSize * 5.1);
        nbMaxLines = freeHeight ~/ (squareSize * 5.1);
        if(nbMaxLines <= 0){
          nbMaxLines = 1;
        }
      }
      //On calcule l'espace libre restant sur la ligne pour centrer les pièces
      double leftOver = ((width / (squareSize * 5.1)) - nbPieceOnLine) * (squareSize * 5.1);
      double startX = leftOver / 2;
      double incrX = squareSize * 5.1;
      double decrY = squareSize * 5.1;
      Offset baseOffset = Offset(startX, height - squareSize * 5.1);
      int i = 0;
      for(Piece p in _pieces){
        initOffsetPiece(p, baseOffset);
        i++;
        if(i == nbPieceOnLine){
          i = 0;
          baseOffset =  Offset(startX ,baseOffset.dy - decrY);
        }
        else{
          baseOffset = Offset(baseOffset.dx + incrX,baseOffset.dy);
        }
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
      
      Offset c2 = _baseOffsetMap[p]![p.getCoordC()].getOffset();
      for (MutableOffset o in _baseOffsetMap[p]!) {
        o.setOffset(Offset(o.getOffset().dy, -o.getOffset().dx));
      }
      updateOffsetPiece(_baseOffsetMap[p]![p.getCoordC()], _baseOffsetMap[p]!, c2);

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

      Offset c2 = _baseOffsetMap[p]![p.getCoordC()].getOffset();
      for (MutableOffset o in _baseOffsetMap[p]!) {
        o.setOffset(Offset(-o.getOffset().dx, o.getOffset().dy));
      }
      updateOffsetPiece(_baseOffsetMap[p]![p.getCoordC()], _baseOffsetMap[p]!, c2);

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
                  _addPiece(data, StdCoords.fromInt(i, j));                   
                                  
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
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ),
                    ColoredBox(
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: _g.getNbCols() * squareSize.toDouble(),
                          child: snapshot.data as Widget,
                        ),
                      ),
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
    return _g.getNbRows() == nbPiecePlaced();
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> children = createChildren(_pieces);
    children.addAll(createDraggablePieces());
    if(checkWinCondition()){
        //on return le widget de la win
        Offset position = (key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
        children.addAll(
            [
             Positioned(
              left: position.dx,
              top: position.dy,
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
                left: position.dx + (2 * squareSize),
                top: position.dy + (_g.getNbRows() * squareSize) / 2,
                child :
                  FloatingActionButton(
                    onPressed: (){
                      setState(() {
                        _g.reset();
                        for(Piece p in _pieces){
                          int i = 0;
                          for (MutableOffset o in _offsetmap[p]!) {
                            o.setOffset(_baseOffsetMap[p]![i].getOffset());
                            i++;
                          }
                        }
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
                _remove(p, const Offset(0,0));
              },
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  int i = 0;
                  for (MutableOffset o in _offsetmap[p]!) {
                    o.setOffset(_baseOffsetMap[p]![i].getOffset());
                    i++;
                  }
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
    ret.addAll([
      Positioned(
        left: MediaQuery.of(context).size.width * (80/100),
        top: MediaQuery.of(context).size.height * (10/100),
        child :
      FloatingActionButton(onPressed: (){
        if(_currPiece != null && !_g.pieceAlreadyPlaced(_currPiece!)){
           _rotate(_currPiece!);
         }   
      },
      child : const Icon(Icons.arrow_back))),
      Positioned(
        left: MediaQuery.of(context).size.width * (80/100),
        top: MediaQuery.of(context).size.height * (20/100),
        child :
      FloatingActionButton(onPressed: (){
        if(_currPiece != null && !_g.pieceAlreadyPlaced(_currPiece!)){
          _flip(_currPiece!);
        }
      },
      child: const Icon(Icons.flip),)),]);
    return ret;
  }
}