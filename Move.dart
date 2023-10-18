import "Coords.dart";
import '../interfaces/IMove.dart';
import '../interfaces/IPiece.dart';
class Move extends IMove{
  late IPiece _p;
  late List<Coords> _c;

  Move(IPiece p,List<Coords> c){
    _p = p;
    _c = c;
  }

  // REQUETES
	/* coordsMove() : renvoie les coordonnées du coup */
  @override
	List<Coords> coordsMove(){
    return _c;
  }
  
	/* piece() : renvoie la pièce du coup */
  @override
	IPiece piece(){
    return _p;
  }
}