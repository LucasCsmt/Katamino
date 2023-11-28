/// Interface qui définit les matrices
/// @inv: getNbRows() > 0 && getNbCols() > 0
///    getNbRows() == getNbCols() => isSquare()
///    getMat() != null
///    getMat().length = getNbRows()
///    forall i, 0 <= i < getNbRows() : getMat()[i].length == getNbCols()
///    forall i, 0 <= i < getNbRows() :
///       forall j, 0 <= j < getNbCols() : get(i, j) == getMat()[i][j]
/// @cons:
///   $ARGS$: int n, E e
///   $PRE$: nbRows > 0
///   $POST$: getNbRows() == getNbCols == n && isSquare()
/// 
/// @cons:
///  $ARGS$: int nbRows, int nbCols, E e
///  $PRE$: nbRows > 0 && nbCols > 0
///  $POST$: getNbRows() == nbRows && getNbCols() == nbCols
abstract class IMat<E> {
  
  // REQUETES : 

  /// Renvoie la matrice sous la forme d'une liste de liste
  List<List<E>> getMat();

  /// Renvoie le nombre de lignes de la matrice
  int getNbRows();

  /// Renvoie le nombre de colonnes de la matrice
  int getNbCols();
  
  /// Renvoie vrai si la matrice est carrée
  bool isSquare();

  /// Renvoie l'élément à la ligne i et à la colonne j
  /// @pre: 0 <= i < getNbRows() && 0 <= j < getNbCols()
  E get(int i, int j);

  // COMMANDES : 

  /// Change l'élément à la ligne i et à la colonne j
  /// @pre: 0 <= i < getNbRows() && 0 <= j < getNbCols()
  /// @post: get(i, j) = e
  void set(int i, int j, E e);

  /// Supprime la ligne i de la matrice
  /// 
  /// @pre: 0 <= i < getNbRows()
  /// 
  /// @post: 
  ///  getNbRows() = old getNbRows() - 1
  ///  forall j, 0 <= j < getNbCols() :
  ///       get(i, j) = null
  ///  forall i, 0 <= i < old getNbRows() : 
  ///      forall j, 0 <= j < getNbCols() : 
  ///       i < j => get(i, j) = old get(i, j)
  ///       i >= j => get(i, j) = old get(i + 1, j)
  void removeRow(int i);

  /// Supprime la colonne j de la matrice
  /// 
  /// @pre: 0 <= j < getNbCols()
  /// 
  /// @post: getNbCols() = old getNbCols() - 1
  ///    forall i, 0 <= i < getNbRows() : 
  ///     get(i, j) = null  
  /// 
  ///   forall i, 0 <= i < getNbRows() :
  ///    forall j, 0 <= j < old getNbCols() :
  ///     j < i => get(i, j) = old get(i, j)
  ///     j >= i => get(i, j) = old get(i, j + 1)
  void removeCol(int j);

  /// ### Description
  /// Ajoute une ligne à la matrice à la position i
  /// ### Pre-conditions
  /// - `0 <= i < getNbRows()`
  /// ### Post-conditions
  /// - `getNbRows() = old getNbRows() + 1`
  /// - `forall j, 0 <= j < getNbCols() :
  ///    get(i, j) = e`
  /// - `forall j, 0 <= j < getNbCols() :`
  ///   `j < i => get(i + 1, j) = old get(i, j)`
  ///   `j >= i => get(i + 1, j) = old get(i + 1, j)`
  /// - `forall j, 0 <= j < getNbCols() :`
  ///  `get(i, j) = e`
  void addRowAt(int i, E e);

  /// ### Description
  /// Ajoute une colonne à la matrice à la position j
  /// ### Pre-conditions
  /// - `0 <= j < getNbCols()`
  /// ### Post-conditions
  /// - `getNbCols() = old getNbCols() + 1`
  /// - `forall i, 0 <= i < getNbRows() :`
  ///  `get(i, j) = e`
  /// - `forall i, 0 <= i < getNbRows() :`
  ///  `i < j => get(i, j + 1) = old get(i, j)`
  /// `i >= j => get(i, j + 1) = old get(i, j + 1)`
  /// - `forall i, 0 <= i < getNbRows() :`
  /// `get(i, j) = e`
  void addColAt(int j, E e);

}