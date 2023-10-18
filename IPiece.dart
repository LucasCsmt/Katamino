import '../implementations/Coords.dart';

abstract class IPiece {
	
	// REQUETES
	/* path() : renvoie une liste de coordonnées représentant le
		 chemin pour construire la pièce.*/
	List<Coords> path();
  
  int ord();
	/* relativePath() : renvoie une liste de coordonnées représentant
		 le chemin relatif pour construire la pièce à partir d'une 
		 certaine coordonnée. */
	List<Coords> relativePath();
	
	// COMMANDES
	/* buildRelativePath() : prend en entrée des coordonnées et 
		 construit le chemin relatif de la pièce à partir de ces 
		 coordonnées. */
	void buildRelativePath(List<Coords> coords);

	/* rotate() : modifie le chemin de la pièce afin que celui ci
	   décrive cette même pièce mais tourner de 90° vers la droite */	
	void rotate();

	/* flip() : modifie le chemin de la pièce afin que celui ci
		 décrive cette même pièce mais miroir.*/
	void flip();

}