import "icoords.dart";

class StdCoords extends ICoords {
  // ATTRIBUTS :
  final List<int> _coords;

  // CONSTRUCTEURS :

  const StdCoords.fromList(List<int> coords) : _coords = coords;
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
  ICoords getRelative(ICoords c){
    return StdCoords.fromInt(getXCoords() - c.getXCoords(), getYCoords() - c.getYCoords());
  }

  // COMMANDES :

  @override
  void setXCoords(int x){
    _coords[0] = x;
  }

  @override
  void setYCoords(int y){
    _coords[1] = y;
  }

  @override
  void setCoords(int x, int y){
    _coords[0] = x;
    _coords[1] = y;
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
  void rotateCoords(ICoords c){
    ICoords o = getRelative(c);
    if(o.getXCoords() < 0 && o.getYCoords() < 0 ||
       o.getXCoords() > 0 && o.getYCoords() > 0){
        setYCoords(c.getYCoords() - o.getYCoords());
    } else if(o.getXCoords() < 0 && o.getYCoords() > 0 ||
            o.getXCoords() > 0 && o.getYCoords() < 0){
        setXCoords(c.getXCoords() - o.getXCoords());
    } else if(o.getXCoords() == 0 && o.getYCoords() != 0){
       setXCoords(c.getXCoords() + o.getYCoords());
       setYCoords(c.getYCoords());
    } else if(o.getXCoords() != 0 && o.getYCoords() == 0){
      setXCoords(c.getXCoords());
      setYCoords(c.getYCoords() - o.getXCoords());
    }
  }

  @override
  void flipCoords(ICoords c){
    ICoords o = getRelative(c);
    setXCoords((- o.getXCoords() + c.getXCoords()));
    setYCoords((- o.getYCoords() + c.getYCoords()));
  }

  @override 
  String toString(){
    return "(${getXCoords()}, ${getYCoords()})";
  }
}