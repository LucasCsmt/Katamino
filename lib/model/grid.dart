import 'piece.dart';
import '../../util/std_coords.dart';
import '../../util/std_mat.dart';

class Grid extends StdMat<int>{
  // ATTRIBUTS
  late Map<Piece, StdCoords> _pieces_placed; 
  // Matrice<int> 
  
  // CONSTRUCTEURS
  Grid (int nbRows, int nbCols) : super.fromRowsAndCols(nbRows, nbCols, -1){
    _pieces_placed = {};
  }

  // REQUETES

  bool pieceAlreadyPlaced(Piece p){
    return _pieces_placed.containsKey(p);
  }

  bool coordsOfPiece(Piece p, StdCoords c){
    return _pieces_placed[p] == c;
  } 

  StdCoords getCoordsOfPiece(Piece p){
    if(!_pieces_placed.containsKey(p)){
      throw ArgumentError("Piece non présente");
    }
    return _pieces_placed[p]!;
  }

  bool _isIn(Piece p, StdCoords c){
    StdCoords center = p.getCenter();
    for(int i = 0; i < p.getPath().getPathLength(); i++){
      StdCoords k = p.getPath().getCoords(i);
      k = k.getRelative(center);
      if(k.getXCoords() + c.getXCoords() < 0 || k.getXCoords() + c.getXCoords() >= getNbRows() || k.getYCoords() + c.getYCoords() < 0 || k.getYCoords() + c.getYCoords() >= getNbCols()){
        return false;
      }
    }
    return true;
  }
  bool _isFree(Piece p, StdCoords c){
    StdCoords center = p.getCenter();
    for(int i = 0; i < p.getPath().getPathLength(); i++){
      StdCoords k = p.getPath().getCoords(i);
      k = k.getRelative(center);
      if(getMat()[k.getXCoords() + c.getXCoords()][k.getYCoords() + c.getYCoords()] != -1){
        return false;
      }
    }
    return true;
  }
  
  bool isValid(Piece p, StdCoords c){
    return _isIn(p, c) && _isFree(p, c);
  }

  // COMMANDES
  // rajouter dans Map
  // rajouter dans Matrice ordinal
  // suit path de P à partir de c
  // Si case déjà occupée, throw ArgumentError ou si case en dehors
  // de la grille throw ArgumentError
  void putPiece(Piece p, StdCoords c){
    if(!isValid(p, c)){
      throw ArgumentError("Piece invalide");
    }

    for(int i = 0; i < p.getPath().getPathLength(); i++){
      StdCoords center = p.getCenter();
      // center = c 
      for(int i = 0; i < p.getPath().getPathLength(); i++){
        StdCoords k = p.getPath().getCoords(i);
        k = k.getRelative(center);
        k.setCoords(k.getXCoords() + c.getXCoords(), k.getYCoords() + c.getYCoords());
        getMat()[k.getXCoords()][k.getYCoords()] = p.index();
      }
    }
    _pieces_placed[p] = c; 
  }

  // get(c.getXCoords(), c.getYCoords()) == p.ordinal()
  // _pieces_placed[PieceType.values[p.ordinal()]] = c
  // l = p.getPath().getCoords()
  // for i in 0 < i < l.length : get(c.getXCoords() + l[i].getXCoords(), c.getYCoords() + l[i].getYCoords()) == p.ordinal()
  void removePiece(Piece p){
    if(!_pieces_placed.containsKey(p)){
      throw ArgumentError("Piece non présente");
    }
    StdCoords c = _pieces_placed[p]!;
    for(int i = 0; i < p.getPath().getPathLength(); i++){
      StdCoords center = p.getCenter();
      // center = c 
      for(int i = 0; i < p.getPath().getPathLength(); i++){
        StdCoords k = p.getPath().getCoords(i);
        k = k.getRelative(center);
        k.setCoords(k.getXCoords() + c.getXCoords(), k.getYCoords() + c.getYCoords());
        getMat()[k.getXCoords()][k.getYCoords()] = -1;
      }
    }
    _pieces_placed.remove(p);
  }

  void reset(){
    List<Piece> piecesToRemove = _pieces_placed.keys.toList();
    for(Piece p in piecesToRemove){
      removePiece(p);
    }
  }
  // Future<Widget> renderGrid() async{
  //   return SizedBox(
  //     height: getNbRows() * 50.0,
  //     width: getNbCols() * 50.0,
  //     child: GridView.builder(
  //       itemCount: getNbRows() * getNbCols(),
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: getNbCols(),
  //       ),
  //       itemBuilder: (BuildContext context, int index){
  //         int i = index ~/ getNbCols();
  //         int j = index % getNbCols();
  //         return Container(
  //           decoration: BoxDecoration(
  //             color: (get(i, j) == -1) ? Colors.white : Piece.colors[get(i, j)],
  //             border: Border.all(
  //               color : Colors.black,
  //               width: 1,
  //             ),
  //           ),
  //           child: DragTarget(
  //             builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
  //               return Container(
                  
  //                 color: (get(i, j) == -1) ? ((candidateData.isEmpty)? Colors.white : (candidateData[0] != Null && isValid(candidateData[0], StdCoords.fromInt(i, j))) ? Colors.grey : Colors.red) : Piece.colors[get(i, j)],
  //                 child: Text(get(i, j).toString()),
  //               );
  //             },
  //             onAccept: (data) {
  //               if(getMat()[i][j] != -1){
  //                 throw ArgumentError("Case déjà occupée");
  //               } else {
  //                 putPiece(data as Piece, StdCoords.fromList([i, j]));
  //               }
  //             },
  //             onWillAccept: (data){
  //               if(data.runtimeType == Null){
  //                 return false;
  //               }
  //               return isValid(data as Piece, StdCoords.fromList([i, j]));
  //             },
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
