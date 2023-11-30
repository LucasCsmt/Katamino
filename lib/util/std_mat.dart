import 'imat.dart';

class StdMat<E> implements IMat<E>{

  // ATTRIBUTS

  late List<List<E>> _mat;

  // CONSTRUCTEURS

  StdMat.fromInt(int n, E e){
    if(n <= 0){
      throw ArgumentError("n <= 0");
    }
    _mat = List.generate(n, (index) => List.generate(n, (index) => e));
  }

  StdMat.fromRowsAndCols(int nbRows, int nbCols, E e){
    if(nbRows < 0 || nbCols < 0){
      throw ArgumentError("nbRows < 0 || nbCols < 0");
    }
    _mat = List.generate(nbRows, (index) => List.generate(nbCols, (index) => e));
  }

  // REQUETES :

  @override
  List<List<E>> getMat(){
    return _mat;
  }
  @override
  int getNbRows(){
    return _mat.length;
  }
  @override 
  int getNbCols(){
    return _mat[0].length;
  }
  @override
  bool isSquare(){
    return getNbRows() == getNbCols();
  }

  @override 
  E get(int i, int j){
    if(i < 0 || i >= getNbRows() || j < 0 || j >= getNbCols()){
      throw ArgumentError("i < 0 || i >= getNbRows() || j < 0 || j >= getNbCols()");
    }
    return _mat[i][j];
  }

  // COMMANDES :

  @override
  void set(int i, int j, E e){
    if(i < 0 || i >= getNbRows() || j < 0 || j >= getNbCols()){
      throw ArgumentError("i < 0 || i >= getNbRows() || j < 0 || j >= getNbCols()");
    }
    _mat[i][j] = e;
  }

  @override 
  void removeRow(int i){
    if(i < 0 || i >= getNbRows()){
      throw ArgumentError("i < 0 || i >= getNbRows()");
    }
    _mat.removeAt(i);
  }

  @override
  void removeCol(int j){
    if(j < 0 || j >= getNbCols()){
      throw ArgumentError("j < 0 || j >= getNbCols()");
    }

    for(int i = 0; i < getNbRows(); i++){
      _mat[i].removeAt(j);
    }
  }

  @override 
  void addRowAt(int i, E e){
    if(i < 0 || i > getNbRows()){
      throw ArgumentError("i < 0 || i > getNbRows()");
    }
    _mat.insert(i, List.generate(getNbCols(), (index) => e));
  }

  @override 
  void addColAt(int j, E e){
    if(j < 0 || j > getNbCols()){
      throw ArgumentError("j < 0 || j > getNbCols()");
    }
    for(int i = 0; i < getNbRows(); i++){
      _mat[i].insert(j, e);
    }
  }
}