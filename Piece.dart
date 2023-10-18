import 'package:sandbox1/implementations/KPiece.dart';

import '../implementations/Coords.dart';
import '../interfaces/IPiece.dart';
class Piece extends IPiece{
  late KPiece _type;
  late List<Coords> _currPath;

  Piece(KPiece p){
    _type = p;
    _currPath = p.path;
  }
	// REQUETES
	/* path() : renvoie une liste de coordonnées représentant le
		 chemin pour construire la pièce.*/
	@override
  List<Coords> path(){
    return _currPath;
  }

  @override
  int ord(){
    return _type.index;
  }
    
	/* relativePath() : renvoie une liste de coordonnées représentant
		 le chemin relatif pour construire la pièce à partir d'une 
		 certaine coordonnée. */
  @override
	List<Coords> relativePath(){
    return [];
  }
	
	// COMMANDES
	/* buildRelativePath() : prend en entrée des coordonnées et 
		 construit le chemin relatif de la pièce à partir de ces 
		 coordonnées. */
  @override
	void buildRelativePath(List<Coords> coords){
    return;
  }

	/* rotate() : modifie le chemin de la pièce afin que celui ci
	   décrive cette même pièce mais tourner de 90° vers la droite */	
  @override
	void rotate(){
    return;
  }

	/* flip() : modifie le chemin de la pièce afin que celui ci
		 décrive cette même pièce mais miroir.*/
  @override
	void flip(){
    return;
  }

}