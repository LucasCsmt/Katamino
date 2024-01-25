import 'package:flutter/material.dart';
import 'package:katamino/widget/game.dart';
import '../../util/path.dart' as pa;
import '../../util/std_coords.dart';
import 'dart:math' as math;

/// Classe représentant une pièce
class Piece {
  // ATTRIBUTS
  pa.Path _path;
  StdCoords _center;
  int _ordinal;
  int _coordC;
  int _rotateState;

  static final List<MaterialColor> colors = [
    Colors.red,
    Colors.cyan,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.pink,
    Colors.orange,
    Colors.grey,
    Colors.lightGreen,
    Colors.brown,
    Colors.indigo
  ];
  // CONSTRUCTEURS
  Piece(pa.Path path, StdCoords center, int pieceNum)
      : _path = path,
        _center = center,
        _ordinal = pieceNum,
        _coordC = 0,
        _rotateState = 0;

  Piece.lshape()
      : _path = pa.Path([
          StdCoords.fromList([2, 0]),
          StdCoords.fromList([3, 0]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([2, 2]),
          StdCoords.fromList([2, 3]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 3,
        _ordinal = 0,
        _rotateState = 0;

  Piece.ushape()//IMPORTANT METTRE 2,2
      : _path = pa.Path([
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([3, 1]),
          StdCoords.fromList([1, 2]),
          StdCoords.fromList([3, 2]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 1,
        _ordinal = 1,
        _rotateState = 0;

  Piece.fshape()
      : _path = pa.Path([
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([2, 0]),
          StdCoords.fromList([2, 2]),
          StdCoords.fromList([3, 0]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 3,
        _ordinal = 2,
        _rotateState = 0;  

  Piece.ishape()//IMPORTANT METTRE 2,2
      : _path = pa.Path([
          StdCoords.fromList([1, 0]),
          StdCoords.fromList([1, 2]),
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([1, 3]),
          StdCoords.fromList([1, 4]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 1,
        _ordinal = 3,
        _rotateState = 0;

  Piece.nshape()//IMPORTANT METTRE 2,2
      : _path = pa.Path([
          StdCoords.fromList([1, 2]),
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([1, 3]),
          StdCoords.fromList([2, 0]),
          StdCoords.fromList([2, 1]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 1,
        _ordinal = 4,
        _rotateState = 0;

  Piece.pshape()
      : _path = pa.Path([
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([1, 2]),
          StdCoords.fromList([2, 0]),
          StdCoords.fromList([2, 2]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 4,
        _ordinal = 5,
        _rotateState = 0;

  Piece.tshape()
      : _path = pa.Path([
          StdCoords.fromList([1, 0]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([2, 0]),
          StdCoords.fromList([2, 2]),
          StdCoords.fromList([3, 0]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 3,
        _ordinal = 6,
        _rotateState = 0;

  Piece.vshape()
      : _path = pa.Path([
          StdCoords.fromList([1, 0]),
          StdCoords.fromList([1, 2]),
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([2, 2]),
          StdCoords.fromList([3, 2]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 3,
        _ordinal = 7,
        _rotateState = 0;

  Piece.wshape()
      : _path = pa.Path([
          StdCoords.fromList([1, 0]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([2, 2]),
          StdCoords.fromList([3, 2]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 3,
        _ordinal = 8,
        _rotateState = 0;

  Piece.xshape()
      : _path = pa.Path([
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([2, 0]),
          StdCoords.fromList([2, 2]),
          StdCoords.fromList([3, 1]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 3,
        _ordinal = 9,
        _rotateState = 0;       

  Piece.yshape()
      : _path = pa.Path([
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([2, 0]),
          StdCoords.fromList([2, 2]),
          StdCoords.fromList([2, 3]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 3,
        _ordinal = 10,
        _rotateState = 0;

  Piece.zshape()
      : _path = pa.Path([
          StdCoords.fromList([1, 0]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([2, 0]),
          StdCoords.fromList([2, 2]),
          StdCoords.fromList([3, 2]),
        ]),
        _center = StdCoords.fromList(
          [2, 2],
        ),
        _coordC = 3,
        _ordinal = 11,
        _rotateState = 0;

  

  // REQUETES
  /// Renvoie le chemin de la pièce
  pa.Path getPath() {
    return _path;
  }

  int index() {
    return _ordinal;
  }

  /// Renvoie le centre de la pièce
  StdCoords getCenter() {
    return _center;
  }

  int getCoordC() {
    return _coordC;
  }

  MaterialColor getColor(){
    return colors[_ordinal];
  }

  int getRotateState() {
    return _rotateState;
  }

  // COMMANDES

  void setRotateState(int rotateState) {
    _rotateState = rotateState;
  }
  
  void rotate() {
    for (int i = 0; i < _path.getPathLength(); i++) {
      _path.getCoords(i).rotateCoords(_center);
      _rotateState = (_rotateState + 1) % 4;
    }
  }

  void flip() {
    for (int i = 0; i < _path.getPathLength(); i++) {
        _path.getCoords(i).flipCoords(_center);
    }
  }

  Offset centerDragAnchorStrategy(Draggable<Object> d, BuildContext context, Offset position) {
    return Offset(25, 25);
  }
}


class PiecePainter extends CustomPainter {
  Piece _piece;
  Color _color;
  List<MutableOffset> _offsets = [];
  MutableOffset _off = MutableOffset(Offset(0, 0));
  PiecePainter(this._piece, this._color);

  PiecePainter.good(this._piece, this._color, this._offsets, this._off);

  @override
  void paint(Canvas canvas, Size size) {
    if (_offsets.length == 0) {
      Paint paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0;
      Path path = Path();
      for (int i = 0; i < _piece.getPath().getPathLength(); i++) {
        StdCoords c = _piece.getPath().getCoords(i);
        double squareSize = size.width / 5;
        Rect squareRect = Rect.fromLTWH(
            (c.getYCoords()) * squareSize,
            (c.getXCoords()) * squareSize,
            squareSize,
            squareSize);
        path.addRect(squareRect);
      }
      path.close();
      canvas.drawPath(path, paint);

      // Remplit les carrés avec la couleur de l'index
      paint = Paint()
        ..color = _color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    } else {
      Paint paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0;
      Path path = Path();
      double x = _offsets[_piece.getCoordC()].getOffset().dx;
      double y = _offsets[_piece.getCoordC()].getOffset().dy;
      for (MutableOffset o in _offsets) {
      
        double squareSize = size.width / 5;
        
        Rect squareRect = Rect.fromLTWH(
            (o.getOffset().dx),
            (o.getOffset().dy),
            squareSize,
            squareSize);
        if (_offsets[_piece.getCoordC()] == o) {
          squareRect = Rect.fromLTWH(
            (0),
            (0),
            squareSize,
            squareSize);
        } else {
          squareRect = Rect.fromLTWH(
              (o.getOffset().dx - x),
              (o.getOffset().dy - y),
              squareSize,
              squareSize);
        }
        path.addRect(squareRect);
      }
      path.close();
      canvas.drawPath(path, paint);

      // Remplit les carrés avec la couleur de l'index
      paint = Paint()
        ..color = _color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


