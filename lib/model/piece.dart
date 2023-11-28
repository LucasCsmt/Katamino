import 'package:flutter/material.dart';
import '../../util/path.dart';
import '../../util/std_coords.dart';

/// Classe représentant une pièce
class Piece{
  // ATTRIBUTS
  Path _path;
  StdCoords _center;
  int _ordinal;

  static final List<MaterialColor> colors = [
    Colors.yellow,
    Colors.cyan,
  ];
  // CONSTRUCTEURS
  Piece(Path path, StdCoords center, int pieceNum) : _path = path, _center = center, _ordinal = pieceNum;

  Piece.lshape() : _path = Path([
    StdCoords.fromList([2, 0]),
    StdCoords.fromList([3, 0]),
    StdCoords.fromList([2, 1]),
    StdCoords.fromList([2, 2]),
    StdCoords.fromList([2, 3]),
  ]), _center = StdCoords.fromList([2, 2],), _ordinal = 0;

  Piece.ushape() : _path = Path([
    StdCoords.fromList([1, 1]),
    StdCoords.fromList([2, 1]), 
    StdCoords.fromList([3, 1]),
    StdCoords.fromList([1, 2]),
    StdCoords.fromList([3, 2]),
  ]), _center = StdCoords.fromList([2, 2],), _ordinal = 1;
  

  // REQUETES
  /// Renvoie le chemin de la pièce
  Path getPath(){
    return _path;
  }

  int index(){
    return _ordinal;
  }

  /// Renvoie le centre de la pièce
  StdCoords getCenter(){
    return _center;
  }

  void rotate(){
    for (int i = 0; i < _path.getPathLength(); i++) {
      _path.getCoords(i).rotateCoords(_center);
    }
  }

  Widget getWidget(){
    return SizedBox(
      width : 100,
      height : 100,
      child: CustomPaint(
        painter: PiecePainter(this),
      ),
    );
  }
}

class PiecePainter extends CustomPainter{
  final Piece _piece;

  const PiecePainter(this._piece);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = _piece.getPath();
    for (int i = 0; i < path.getPathLength(); i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          path.getCoords(i).getXCoords() * 25,
          path.getCoords(i).getYCoords() * 25,
          25,
          25,
        ),
        Paint()..color = Colors.red,
      );
    }
  }

  @override
  bool shouldRepaint(PiecePainter oldDelegate) => false;
}
