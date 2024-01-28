import 'std_coords.dart';

/// Classe représentant des chemins de coordonnées
class Path{

  // ATTRIBUTS :
  final List<StdCoords> _coords;

  // CONSTRUCTEURS :
  const Path(coords) : _coords = coords;

  // REQUETES :
  /// Renvoie les ième coordonnées du chemin
  /// ### pre-conditions
  /// - `0 <= i < getPathLength()`
  StdCoords getCoords(int i) {
    if(i < 0 || i >= getPathLength()){
      throw ArgumentError("i < 0 || i >= getNbCoords()");
    }
    return _coords[i];
  }

  /// Renvoie la longueur du chemin
  int getPathLength(){
    return _coords.length;
  }

  List<StdCoords> getCoordsList(){
    return _coords;
  }

  // COMMANDES :
  /// Ajoute des coordonnées au chemin
  /// ### post-conditions
  /// - `getPathLength() = old getPathLength() + 1`
  /// - `getCoords(getPathLength() - 1) = c`
  void addCoords(StdCoords c){
    _coords.add(c);
  }
  /// Ajoute des coordonnées au chemin à partir d'une liste
  /// ### post-conditions
  /// - `getPathLength() = old getPathLength() + coords.length`
  /// - `forall i, 0 <= i < coords.length : getCoords(getPathLength() - coords.length + i) = coords[i]`
  void addFromList(List<StdCoords> coords){
    _coords.addAll(coords);
  }

  /// Remplace les coordonnées du chemin par celles de la liste
  /// ### post-conditions
  /// - `getPathLength() = coords.length`
  /// - `forall i, 0 <= i < coords.length : getCoords(i) = coords[i]`
  void truncate(List<StdCoords> coords){
    _coords.clear();
    _coords.addAll(coords);
  }

  /// Retire les ième coordonnées du chemin
  /// ### pre-conditions
  /// - `0 <= i < getPathLength()`
  /// ### post-conditions
  /// - `getPathLength() = old getPathLength() - 1`
  /// - `forall j, 0 <= j < i : getCoords(j) = old getCoords(j)`
  /// - `forall j, i <= j < getPathLength() : getCoords(j) = old getCoords(j + 1)`
  void removeCoords(int i){
    if(i < 0 || i >= getPathLength()){
      throw ArgumentError("i < 0 || i >= getNbCoords()");
    }
    _coords.removeAt(i);
  }

  /// Réinitialise le chemin
  /// ### post-conditions
  /// - `getPathLength() = 0`
  void clear(){
    _coords.clear();
  }
}