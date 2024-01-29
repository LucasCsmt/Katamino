import 'icoords.dart';
import '../model/piece.dart';
class Move{
  final ICoords _c;
  final Piece _p;

  const Move(ICoords c, Piece p) : _c = c, _p = p;

  ICoords getCoords(){
    return _c;
  }

  Piece getPiece(){
    return _p;
  }
}