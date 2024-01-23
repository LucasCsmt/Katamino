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
  Offset _offset;

  static final List<MaterialColor> colors = [
    Colors.red,
    Colors.cyan,
    Colors.blue,
  ];
  // CONSTRUCTEURS
  Piece(pa.Path path, StdCoords center, int pieceNum)
      : _path = path,
        _center = center,
        _ordinal = pieceNum,
        _coordC = 0,
        _rotateState = 0,
        _offset = Offset(center.getXCoords() * 50, center.getYCoords() * 50);


  Piece.lshape()
      : _path = pa.Path([
          StdCoords.fromList([2, 0]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([3, 0]),
          StdCoords.fromList([2, 2]),
          StdCoords.fromList([2, 3]),
        ]),
        _center = StdCoords.fromList(
          [2, 1],
        ),
        _coordC = 1,
        _ordinal = 0,
        _rotateState = 0,
        _offset = Offset(2 * 50, 2 * 50);

  Piece.ushape()
      : _path = pa.Path([
          StdCoords.fromList([1, 1]),
          StdCoords.fromList([2, 1]),
          StdCoords.fromList([3, 1]),
          StdCoords.fromList([1, 2]),
          StdCoords.fromList([3, 2]),
        ]),
        _center = StdCoords.fromList(
          [2, 1],
        ),
        _coordC = 1,
        _ordinal = 1,
        _rotateState = 0,
        _offset = Offset(4 * 50, 4 * 50);

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

  Offset getOffset() {
    return _offset;
  }

  void setOffset(Offset offset) {
    _offset = offset;
  }

  Widget getWidget() {
    // Affiche la pièce en sachant que toutes les pièces sont contenu dans des
    // matrices carrées de taille 5
    return _draggablePiece(); 
  }

  Offset centerDragAnchorStrategy(Draggable<Object> d, BuildContext context, Offset position) {
    return Offset(25, 25);
  }
    Widget _draggablePiece() {
      // matrices carrées de taille 5
      double yrot = math.pi;
      double zrot = -math.pi / 2; 
      Offset offset = getOffset();
      return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: Draggable<Piece>(
          data: this,
          dragAnchorStrategy: centerDragAnchorStrategy,
          child: Container(
            child: CustomPaint(
                size: Size(250, 250),
                painter: PiecePainter(this, colors[_ordinal]),
            ),
          ),
          feedback: Container(
              child: CustomPaint(
                size: Size(250, 250),
                painter: PiecePainter(this, colors[_ordinal]),
              ),
          ),
          childWhenDragging: Container(
            child: CustomPaint(
                size: Size(250, 250),
                painter: PiecePainter(this, const Color.fromARGB(57, 0, 0, 0)),
              ),
            ),
          onDragEnd: (details) {
            setOffset(details.offset);
          },
          ), 
      );
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


