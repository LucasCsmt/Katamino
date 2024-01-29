import 'icoords.dart';
import '../model/piece.dart';
class Move{
  final ICoords? _c;
  final Piece _p;
  final int _r;
  final int _f;
  final int _t;
  const Move(ICoords c, Piece p, int r, int f, int t) : _c = c, _p = p, _r = r, _f = f, _t = t;

  ICoords? getCoords(){
    return _c;
  }

  Piece getPiece(){
    return _p;
  }

  int getRotation(){
    return _r;
  }

  int getFlip(){
    return _f;
  }
  
  String getType(){
    if(_t == 0){
      return "add";
    }
    else if(_t == 1){
      return "remove";
    }
    else if(_t == 2){
      return "rotate";
    }
    else{
      return "flip";
    }
  }
}