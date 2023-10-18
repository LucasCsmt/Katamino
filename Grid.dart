import 'Coords.dart';
import 'package:flutter/material.dart';
import '../interfaces/IGrid.dart';
import '../interfaces/IMove.dart';
import '../interfaces/IPiece.dart';

class Grid extends IGrid{
  late int _width;
  late int _height;
  late List<List<int>> _grid;
  late Map<IPiece,List<Coords>> _mapPieces;
  Grid(int n,int m){
    _width = n;
    _height = m;
    _grid = [];
    _mapPieces = <IPiece,List<Coords>>{};
    for(int i = 0; i < n; i++){
      _grid.add([]);
      for(int j = 0; j < m; j++){
        _grid.elementAt(i).add(-1);
      }
    }
  }

	Grid.from0(){
    _width = 0;
    _height = 0;
    _grid = [];
    _mapPieces = <IPiece,List<Coords>>{};
  }
  
  Grid.from1(int n){
    _width = n;
    _height = 0;
    _grid = [];
    _mapPieces = <IPiece,List<Coords>>{};
    for(int i = 0; i < n; i++){
      _grid[i] = [-1];
    }
  }

  // REQUETES
	/* grid() : renvoie la grille de jeu associée à la classe*/
	@override
  List<List<int>> grid(){
    return List.of(_grid);
  }

  int w(){
    return _width;
  }

  int h(){
    return _height;
  }
	/* piecePlaced() : renvoie la liste des coordonnées
		 correspondant aux pièces déjà placée sur la grille */
	@override
  List<Coords> piecePlaced(){
    List<Coords> res = [];
    return res;
  }

  MaterialColor colorFromCoords(int i){
    MaterialColor res = Colors.grey;
    switch(i){
      case(-1):
        res = Colors.grey;
        break;
      default:
        res = Colors.cyan;
    }
    return res;
  }

   getValueAtIndex(int index){ 
    int j = index ~/ w();
    int i = index % w();
    return _grid[i][j];
  }
	/* renderGrid() : renvoie le widget correspondant à la forme
		 graphique de la grille de jeu (à voir avec les 
		 spécifications de flutter)*/
	@override
  Widget renderGrid(){
    var l = w()*h();

    return CustomScrollView(
        slivers: <Widget>[SliverToBoxAdapter(
      child:FractionallySizedBox(
        widthFactor: 1/3,
        child: AspectRatio(aspectRatio: w()/h(),
        child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5)
        
        , itemBuilder: (context,index){
          return GridTile(
            child: Container(color: colorFromCoords(getValueAtIndex(index)),
            margin: const EdgeInsets.all(1),
            )
          
          ,);
        },
        itemCount: l,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        ),
        )
    ),),],);
  }

	// COMMANDES 
	
	/* isPlayable(Move) : prend en entrée un Move et renvoie un 
		 true si le coup est jouable, non sinon.
		 <pre> : Move != null 
		 <post> : si le Move ne fait pas dépacer la piece de la
					    grille ou que la pièce n'en chevauche pas une
			        autre => true
			        grid() = old grid()
					    piecePlaced() = old piecePlaced()
				      renderGrid() = old renderGrid()*/
  @override
	bool isPlayable(IMove m){ 
    for(Coords c in m.piece().path()){
      if(_grid[c.getX()][c.getY()] != -1){
        return false;
      }
    } 
    return true;
  }
	/* addPiece(Move) : prend en entrée un Move et rajoute la
	   pièce spécifiée dans le coup sur la grille de jeu 
		 <pre> : isPlayable(Move) && Move != null
	   <post> : grid() = grid() mais avec la pièce dessus
			        piecePlaced().size = old piecePlaced().size + 1
							renderGrid() = renderGrid() mais avec la pièce */
  @override
	void addMove(IMove m){
    _mapPieces[m.piece()] = m.piece().path();
    if(isPlayable(m)){
      print("***OUI");
      for(Coords c in m.piece().path()){
        _grid[c.getX()][c.getY()] = m.piece().ord();
      }
    }
    else{
      print("***NON");
    }
    return;
  }
	/* removePiece(Move) : prend en entrée un Move et enlève la
		 pièce spécifiée dans le coup de la grille de jeu
		 <pre> : Move != null && Move.coordMove in piecePlaced() 
		 <post> : pareil que pour add mais avec - 1*/
  @override
	void removePiece(IMove m){
    return;
  }
}