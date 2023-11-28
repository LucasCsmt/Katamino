import '../util/path.dart';
import '../util/std_coords.dart';

/// Classe représentant une pièce
class Piece{
  // ATTRIBUTS
  final Path _path;
  final StdCoords _center;

  // CONSTRUCTEURS
  const Piece(Path path, StdCoords center) : _path = path, _center = center;

  // REQUETES
  /// Renvoie le chemin de la pièce
  Path getPath(){
    return _path;
  }

  /// Renvoie le centre de la pièce
  StdCoords getCenter(){
    return _center;
  }
}

enum PieceType{

  // PIECES
  lshape(Piece(
    Path([
      StdCoords.fromList([2, 0]),
      StdCoords.fromList([3, 0]),
      StdCoords.fromList([2, 1]),
      StdCoords.fromList([2, 2]),
      StdCoords.fromList([2, 3]),
    ]), StdCoords.fromList([2, 2])
  ));
  // ATTRIBUTS

  final Piece _piece;

  // CONSTRUCTEURS

  const PieceType(this._piece);

  // REQUETES

  Path getPath(){
    return _piece.getPath();
  }

  StdCoords getCenter(){
    return _piece.getCenter();
  }
}