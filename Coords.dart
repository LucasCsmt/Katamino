class Coords{
  final int _x;
  final int _y;
  
  const Coords(this._x, this._y);
  
  const Coords.from0() : _x = 0 , _y = 0;

  const Coords.from1(int n) : _x = n , _y = n;

  getX(){
    return _x;
  }

  getY(){
    return _y;
  }

  equals(Object o){
    if(o is Coords){
      Coords other =  o;
      if(other.getX() == getX() 
      && other.getY() == getY()){
        return true;
      }
    }
    return false;
  }
}
