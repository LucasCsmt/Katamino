import "icoords.dart";
import "dart:math" as Math;

class StdCoords extends ICoords {
  // ATTRIBUTS :
  final List<int> _coords;

  // CONSTRUCTEURS :

  StdCoords.fromList(List<int> coords) : _coords = coords;
  StdCoords.fromInt(int x, int y) : _coords = [x, y];

  // REQUETES :

  @override
  int getXCoords(){
    return _coords[0];
  }

  @override
  int getYCoords(){
    return _coords[1];
  }

  @override
  List<int> getCoords(){
    return _coords;
  }

  @override
  StdCoords getRelative(ICoords c){
    return StdCoords.fromInt(getXCoords() - c.getXCoords(), getYCoords() - c.getYCoords());
  }

  // COMMANDES :

  @override
  void setXCoords(int x){
    int y = getYCoords();
    _coords.clear();
    _coords.addAll([x, y]);
  }

  @override
  void setYCoords(int y){
    int x = getXCoords();
    _coords.clear();
    _coords.addAll([x, y]);
  }

  @override
  void setCoords(int x, int y){
    setXCoords(x);
    setYCoords(y);
  }

  @override
  void setCoordsFromList(List<int> coords){
    if(coords.length != 2){
      throw ArgumentError("coords.length != 2");
    }
    _coords.clear();
    _coords.addAll(coords);
  }

  @override 
  // void rotateCoords(ICoords c){
  //   ICoords o = getRelative(c);
  //   if(o.getXCoords() < 0 && o.getYCoords() < 0 ||
  //      o.getXCoords() > 0 && o.getYCoords() > 0){
  //       setYCoords(c.getYCoords() - o.getYCoords());
  //   } else if(o.getXCoords() < 0 && o.getYCoords() > 0 ||
  //           o.getXCoords() > 0 && o.getYCoords() < 0){
  //       setXCoords(c.getXCoords() - o.getXCoords());
  //   } else if(o.getXCoords() == 0 && o.getYCoords() != 0){
  //      setXCoords(c.getXCoords() + o.getYCoords());
  //      setYCoords(c.getYCoords());
  //   } else if(o.getXCoords() != 0 && o.getYCoords() == 0){
  //     setXCoords(c.getXCoords());
  //     setYCoords(c.getYCoords() - o.getXCoords());
  //   }
  // }

  /// Lachement copié sur stackoverflow
  void rotateCoords(ICoords c){
    setCoords((Math.cos(Math.pi / 2) * (getXCoords() - c.getXCoords()) - Math.sin(Math.pi / 2) * (getYCoords() - c.getYCoords()) + c.getXCoords()).ceil(),
              (Math.sin(Math.pi / 2) * (getXCoords() - c.getXCoords()) + Math.cos(Math.pi / 2) * (getYCoords() - c.getYCoords()) + c.getYCoords()).ceil());
  }

  @override
  void flipCoords(ICoords c){
    setYCoords(c.getYCoords() + (c.getYCoords() - getYCoords()));  
  }

  @override 
  String toString(){
    return "(${getXCoords()}, ${getYCoords()})";
  }
}