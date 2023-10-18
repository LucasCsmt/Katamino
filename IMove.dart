import '../implementations/Coords.dart';
import 'IPiece.dart';

abstract class IMove{

	// REQUETES
	/* coordsMove() : renvoie les coordonnées du coup */
	List<Coords> coordsMove();
  
	/* piece() : renvoie la pièce du coup */
	IPiece piece();
}