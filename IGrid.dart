import 'package:flutter/material.dart';
import 'IMove.dart';
import '../implementations/Coords.dart';

abstract class IGrid {

	// REQUETES
	/* grid() : renvoie la grille de jeu associée à la classe*/
	List<List<int>> grid();

	/* piecePlaced() : renvoie la liste des coordonnées
		 correspondant aux pièces déjà placée sur la grille */
	List<Coords> piecePlaced();

	/* renderGrid() : renvoie le widget correspondant à la forme
		 graphique de la grille de jeu (à voir avec les 
		 spécifications de flutter)*/
	Widget renderGrid();

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
	bool isPlayable(IMove m);
	/* addPiece(Move) : prend en entrée un Move et rajoute la
	   pièce spécifiée dans le coup sur la grille de jeu 
		 <pre> : isPlayable(Move) && Move != null
	   <post> : grid() = grid() mais avec la pièce dessus
			        piecePlaced().size = old piecePlaced().size + 1
							renderGrid() = renderGrid() mais avec la pièce */
	void addMove(IMove m);
	/* removePiece(Move) : prend en entrée un Move et enlève la
		 pièce spécifiée dans le coup de la grille de jeu
		 <pre> : Move != null && Move.coordMove in piecePlaced() 
		 <post> : pareil que pour add mais avec - 1*/
	void removePiece(IMove m);
}