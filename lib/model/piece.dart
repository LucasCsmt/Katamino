import 'package:flutter/material.dart';
import '../../util/path.dart' as pa;
import '../../util/std_coords.dart';
import 'dart:math' as math;

/// Classe représentant une pièce
class Piece {
  // ATTRIBUTS
  pa.Path _path;
  StdCoords _center;
  int _ordinal;
  int _rotateState;

  static final List<MaterialColor> colors = [
    Colors.yellow,
    Colors.cyan,
  ];
  // CONSTRUCTEURS
  Piece(pa.Path path, StdCoords center, int pieceNum)
      : _path = path,
        _center = center,
        _ordinal = pieceNum,
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
        _ordinal = 0,
        _rotateState = 0;

  Piece.ushape()
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
        _ordinal = 1,
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

  void rotate() {
    for (int i = 0; i < _path.getPathLength(); i++) {
      _path.getCoords(i).rotateCoords(_center);
      _rotateState = (_rotateState + 1) % 4;
    }
  }

  Widget getWidget() {
    // Affiche la pièce en sachant que toutes les pièces sont contenu dans des
    // matrices carrées de taille 5
    return _draggablePiece(); 
  }
  
    Widget _draggablePiece() {
      // matrices carrées de taille 5
      double yrot = math.pi;
      double zrot = -math.pi / 2; 
      return Draggable<Piece>(
        data: this,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(yrot),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(zrot),
            child: CustomPaint(
              size: Size(250, 250),
              painter: PiecePainter(this, colors[_ordinal]),
            ),
          ),
        ),
        feedback: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(yrot),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(zrot),
            child: CustomPaint(
              size: Size(250, 250),
              painter: PiecePainter(this, colors[_ordinal]),
            ),
          ),
        ),
        childWhenDragging: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(yrot),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(zrot),
            child: CustomPaint(
              size: Size(250, 250),
              painter: PiecePainter(this, const Color.fromARGB(57, 0, 0, 0)),
            ),
          ),
        ),
      );
    }
  }

class PiecePainter extends CustomPainter {
  Piece _piece;
  Color _color;
  PiecePainter(this._piece, this._color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0;
    Path path = Path();
    path.moveTo(0, 0);
    for (int i = 0; i < _piece.getPath().getPathLength(); i++) {
      StdCoords c = _piece.getPath().getCoords(i);
      double squareSize = size.width / 5;
      Rect squareRect = Rect.fromLTWH(
          (4 - c.getXCoords()) * squareSize,
          (4 - c.getYCoords()) * squareSize,
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


