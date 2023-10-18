import 'Coords.dart';

enum KPiece implements Comparable<KPiece>{
	un(path: <Coords>[Coords(0,0),Coords(1,0),Coords(2,0),Coords(3,0),Coords(4,0)]),//le .....
  deux(path: <Coords>[Coords(0,0),Coords(1,0),Coords(2,0),Coords(3,0),Coords(3,1)]),//le ...|
  trois(path: <Coords>[Coords(0,0),Coords(1,0),Coords(2,0),Coords(3,0),Coords(2,1)]),//le ..|. 
  quatre(path: <Coords>[Coords(0,0),Coords(1,0),Coords(1,1),Coords(2,1),Coords(3,1)]),//le .|''
  cinq(path: <Coords>[Coords(0,0),Coords(1,0),Coords(2,0),Coords(0,1),Coords(0,2)]),//le |__
  six(path: <Coords>[Coords(0,0),Coords(1,0),Coords(2,0),Coords(0,1),Coords(1,1)]),//le ||.
  sept(path: <Coords>[Coords(0,0),Coords(1,0),Coords(2,0),Coords(0,1),Coords(2,1)]),//le |.|
  huit(path: <Coords>[Coords(0,0),Coords(0,1),Coords(1,1),Coords(2,1),Coords(2,2)]),//le N
  neuf(path: <Coords>[Coords(0,0),Coords(1,0),Coords(1,1),Coords(1,2),Coords(2,1)]),//le pistolet
  dix(path: <Coords>[Coords(0,0),Coords(1,0),Coords(1,1),Coords(1,2),Coords(2,0)]),//le '|'
  onze(path: <Coords>[Coords(0,0),Coords(1,0),Coords(1,1),Coords(2,1),Coords(2,2)]),//le M/l'escalier
  douze(path: <Coords>[Coords(0,1),Coords(1,0),Coords(1,1),Coords(1,2),Coords(2,1)]);//le +

  const KPiece(
    {
    required this.path
    }
  );

  final List<Coords> path;

  @override
  int compareTo(KPiece other){
    return index - other.index;
  }
}