/// Interface qui défini des coordonnées
/// @inv: getXCoords() <=> this.x
///       getYCoords() <=> this.y
///       getRelative(c) => getXCoords() = c.getXCoords() - old getXCoords() &&
///                         getYCoords() = c.getYCoords() - old getYCoords()
/// @cons: 
///   $ARGS$: 
///     int x, int y  
///   $POST$:
///     getXCoords() = x && getYCoords() = y
/// @cons:
///   $ARGS$:
///    List<int> coords
///  $PRE$:
///   coords.length = 2
///  $POST$:
///   getXCoords() = coords[0] && getYCoords() = coords[1]  
abstract class ICoords{

  const ICoords();

  // REQUETES : 

  /// les coordonnées en x
  int getXCoords();

  /// les coordonnées en y
  int getYCoords();

  /// les coordonnées en x et y sous la forme d'un tableau
  List<int> getCoords();

  /// les coordonnées relatives à c
  /// @post: getRelative(c).getXCoords() = c getXCoords() - getXCoords() &&
  ///       getRelative(c).getYCoords() = c getYCoords() - getYCoords()
  ICoords getRelative(ICoords c);
  // COMMANDES : 

  /// change les coordonnées en x
  /// @post: getXCoords() = x    
  void setXCoords(int x);

  /// change les coordonnées en y
  /// @post: getYCoords() = y
  void setYCoords(int y);

  /// change les coordonnées en x et y
  /// @post: getXCoords() = x && getYCoords() = y 
  void setCoords(int x, int y);

  /// change les coordonnées en x edt y à partir d'une List<int>
  /// @pre: coords.length = 2
  /// @post: getXCoords() = coords[0] && getYCoords() = coords[1] 
  void setCoordsFromList(List<int> coords);

  /// effectue une rotation d'un quart de tour dans le sens horaire autour de c
  /// @post: Let O ::= getRelative(c) 
  ///       O.getXCoords() < 0 && O.getYCoords() < 0 ||
  ///       O.getXCoords() > 0 && O.getYCoords() > 0 =>
  ///         getXCoords() = old getXCoords() 
  ///         getYCoords() = c.getYCoords()) - O.getYCoords()
  /// 
  ///       O.getXCoords() < 0 && O.getYCoords() > 0 || 
  ///       O.getXCoords() > 0 && O.getYCoords() < 0 =>
  ///         getXCoords() = c.getXCoords() - O.getXCoords()
  ///         getYCoords() = old getYCoords()
  ///       
  ///       O.getXCoords() = 0 && O.getYCoords() != 0 =>
  ///        getXCoords() = (c.getXCoords() + o.getYCoords())
  ///        getYCoords() = c.getYCoords()
  ///       
  ///       O.getXCoords() != 0 && O.getYCoords() = 0 => 
  ///         getXCoords() = c.getXCoords()
  ///         getYCoords() = (c.getYCoords() - o.getXCoords()) 
  void rotateCoords(ICoords c);

  /// effectue une symétrie par rapport à c
  /// @post: flipCoords(c) <=> rotateCoords(c); rotateCoords(c);
  void flipCoords(ICoords c);
}