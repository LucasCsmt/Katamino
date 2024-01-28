
import 'piece.dart';

class Deck {
  // ATTRIBUTS

  final List<Piece> _pieces;

  // CONSTRUCTEUR

  Deck(piece) : _pieces = [piece];

  // REQUETES

  List<Piece> get pieces => _pieces;
  Piece getPiece(int index) => _pieces[index];
  
  // COMMANDES

  void addPiece(Piece piece) {
    _pieces.add(piece);
  }

  void addPieces(List<Piece> pieces){
    _pieces.addAll(pieces);
  }

  void removePiece(Piece piece) {
    if(_pieces.contains(piece)){
      _pieces.remove(piece);
    } else {
      throw Exception("La pièce n'est pas dans le deck");
    }
  }

  void removeAllPieces(){
    _pieces.clear();
  }

  void removePieceAt(int index) {
    _pieces.removeAt(index);
  }

}