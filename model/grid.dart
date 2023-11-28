import 'piece.dart';
import '../util/std_coords.dart';
import '../util/path.dart';
import '../util/std_mat.dart';

abstract class Grid extends StdMat<int>{
  // ATTRIBUTS
  late Map<PieceType, StdCoords> _pieces_placed; 
  // Matrice<int> 
  
  // CONSTRUCTEURS
  Grid (int nbRows, int nbCols) : super.fromRowsAndCols(nbRows, nbCols, -1){
    _pieces_placed = {};
  }

  // REQUETES
  bool _isIn(PieceType p, StdCoords c){
    for(int i = 0; i < p.getPath().getPathLength(); i++){
      StdCoords k = p.getPath().getCoords(i);
      if(k.getXCoords() + c.getXCoords() > getNbRows() || k.getYCoords() + c.getYCoords() > getNbCols()){
        return false;
      }
    }
    return true;
  }
  bool _isFree(PieceType p, StdCoords c){
    for(int i = 0 ; i < p.getPath().getPathLength(); i++){
        StdCoords k = p.getPath().getCoords(i);
        if(getMat()[k.getXCoords() + c.getXCoords()][ k.getYCoords() + c.getYCoords()] != -1){
          return false;
        }  
    }
    return true;
  }
  
  bool isValid(PieceType p, StdCoords c){
    return _isIn(p, c) && _isFree(p, c);
  }

    // COMMANDES
  // rajouter dans Map
  // rajouter dans Matrice ordinal
  // suit path de P à partir de c
  // Si case déjà occupée, throw ArgumentError ou si case en dehors
  // de la grille throw ArgumentError
  void putPiece(PieceType p, StdCoords c);

  // get(c.getXCoords(), c.getYCoords()) == p.ordinal()
  // _pieces_placed[PieceType.values[p.ordinal()]] = c
  // l = p.getPath().getCoords()
  // for i in 0 < i < l.length : get(c.getXCoords() + l[i].getXCoords(), c.getYCoords() + l[i].getYCoords()) == p.ordinal()
  void removePiece(StdCoords c);
}