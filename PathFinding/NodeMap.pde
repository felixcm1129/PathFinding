import java.security.*;
/********************
  Énumération des directions
  possibles
  
********************/
enum Direction {
  EAST, SOUTH, WEST, NORTH
}

/********************
  Représente une carte de cellule permettant
  de trouver le chemin le plus court entre deux cellules
  
********************/
class NodeMap extends Matrix {
  Node start;
  Node end;
  
  ArrayList <Node> wall = new ArrayList <Node>();
  ArrayList <Node> path = new ArrayList <Node>();
  int FinalH;
  boolean debug = false;
  
  NodeMap (int nbRows, int nbColumns) {
    super (nbRows, nbColumns);
  }
  
  NodeMap (int nbRows, int nbColumns, int bpp, int width, int height) {
    super (nbRows, nbColumns, bpp, width, height);
  }
  
  void init() {
    
    cells = new ArrayList<ArrayList<Cell>>();
    
    for (int j = 0; j < rows; j++){
      // Instanciation des rangees
      cells.add (new ArrayList<Cell>());
      
      for (int i = 0; i < cols; i++) {
        Cell temp = new Node(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
        
        // Position matricielle
        temp.i = i;
        temp.j = j;
        
        cells.get(j).add (temp);
      }
    }
    
    println ("rows : " + rows + " -- cols : " + cols);
  }
  
  Boolean getstartCelliswalkable(int i, int j)
  {
    Node find = (Node)cells.get(j).get(i);
    if(find.isWalkable)
    {
      return true;
    }
    return false;
  }
  Boolean getendCelliswalkable(int i, int j)
  {
    Node find = (Node)cells.get(j).get(i);
    if(find.isWalkable)
    {
      return true;
    }
    return false;
  }
  
  /*
    Configure la cellule de départ
  */
  void setStartCell (int i, int j) {
    
    if (start != null) {
      start.isStart = false;
      start.setFillColor(baseColor);
    } 
    
    start = (Node)cells.get(j).get(i);
    start.isStart = true;
    
    start.setFillColor(color (127, 0, 127));
  }
  
  /*
    Configure la cellule de fin
  */
  void setEndCell (int i, int j) {
    
    if (end != null) {
      end.isEnd = false;
      end.setFillColor(baseColor);
    }
    
    end = (Node)cells.get(j).get(i);
    end.isEnd = true;
    
    end.setFillColor(color (127, 127, 0));
  }
  
  /** Met a jour les H des cellules
  doit etre appele apres le changement du noeud
  de debut ou fin
  */
  void updateHs() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        Node current = (Node)cells.get(j).get(i); 
        current.setH( calculateH(current));
      }
    }
  }
  
  // Permet de generer aleatoirement le cout de deplacement
  // entre chaque cellule
  void randomizeMovementCost() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        
        int cost = parseInt(random (0, cols)) + 1;
        
        Node current = (Node)cells.get(j).get(i);
        current.setMovementCost(cost);
       
      }
    }
  }
  
  // Permet de generer les voisins de la cellule a la position indiquee
  void generateNeighbours(int i, int j) {
    Node c = (Node)getCell (i, j);
    if (debug) println ("Current cell : " + i + ", " + j);
    
    
    for (Direction d : Direction.values()) {
      Node neighbour = null;
      
      switch (d) {
        case EAST :
          if (i < cols - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i + 1, j);
          }
          break;
        case SOUTH :
          if (j < rows - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j + 1);
          }
          break;
        case WEST :
          if (i > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i - 1, j);
          }
          break;
        case NORTH :
          if (j > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j - 1);
          }
          break;
      }
      
      if (neighbour != null) {
        if (neighbour.isWalkable) {
          c.addNeighbour(neighbour);
        }
      }
    }
  }
  
  /**
    Génère les voisins de chaque Noeud
    Pas la méthode la plus efficace car ça
    prend beaucoup de mémoire.
    Idéalement, on devrait le faire au besoin
  */
  void generateNeighbourhood() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        generateNeighbours(i, j);
      }
    }
  }
  
  /*
    Permet de trouver le chemin le plus court entre
    deux cellules
  */
  void findAStarPath () {
    // TODO : Complétez ce code
      
      
    if (start == null || end == null) {
      println ("No start and no end defined!");
      return;
    }
    
      ArrayList <Node> Openlist = new ArrayList <Node>();
      ArrayList <Node> Closelist = new ArrayList <Node>();
      
      Node current;
      
      int primeG = 0;
  
      Openlist.add(start);
      
      while(Openlist.size() > 0 && end.parent == null)
      {
          
          current = getLowestCost(Openlist);
           
          if(current == end)
          {
            continue;
          }
          
          Openlist.remove(current);
          Closelist.add(current);
          
          for(int i = 0; i < current.neighbours.size(); i++)
          {
              
                if(Closelist.contains(current.neighbours.get(i)))
                {
                  
                  continue;
                }
                
              
                           
                if(current.neighbours.get(i).isWalkable == true)
                {
                   primeG = calculateCost(current, current.neighbours.get(i));
                   
                   if(!getneighboursOpenlist(Openlist, current.neighbours.get(i)))
                   {
                     Openlist.add(current.neighbours.get(i));
                   }else if(primeG >= current.neighbours.get(i).getG())
                   {
                     continue;
                   }
    
                     current.neighbours.get(i).parent = current;
                     current.neighbours.get(i).G = primeG;
                                  
                }
            
        }
       
       if(end.parent != null)
       {
         generatePath();
       }
    }
    
  }
  
  
  boolean getneighboursOpenlist(ArrayList <Node> openlist, Node neighb)
  {
    
     for(int a  = 0; a<openlist.size(); a++)
     {
             if(openlist.get(a) == neighb)
             {
                return true;
             }
     }
   return false;
  }
  /*
    Permet de générer le chemin une fois trouvée
  */
  void generatePath () {
  
    Node _parent;
    _parent = end.parent;
     while(_parent.parent !=null)
     {
        
       FinalH = calculateH(_parent);

        path.add(_parent);
        _parent = _parent.parent;
     }
  }
  
  /**
  * Cherche et retourne le noeud le moins couteux de la liste ouverte
  * @return Node le moins couteux de la liste ouverte
  */
  private Node getLowestCost(ArrayList<Node> openList) {
    // TODO : Complétez ce code
    
    
    Node lowestnode = openList.get(0);
    
     for(int a  = 0; a<openList.size(); a++)
        {
            if(openList.get(a).getF() < lowestnode.getF())
            {
              lowestnode = openList.get(a);
            }
          
        }
    
    return lowestnode;
  }
  

  
 /**
  * Calcule le coût de déplacement entre deux noeuds
  * @param nodeA Premier noeud
  * @param nodeB Second noeud
  * @return
  */
  private int calculateCost(Node nodeA, Node nodeB) {
    // TODO : Complétez ce code
    int primeG;
    
    primeG = nodeA.getG() + nodeB.movementCost;
    return primeG;
  }
  
  /**
  * Calcule l'heuristique entre le noeud donnée et le noeud finale
  * @param node Noeud que l'on calcule le H
  * @return la valeur H (A LA FIN QUAND ON GENERATE LE PATH)
  */
  private int calculateH(Node node) {
    // TODO : Complétez ce code
    
    return Math.abs(node.j-end.j) + Math.abs(end.i - node.i);
  }
  
  String toStringFGH() {
    String result = "";
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {

        Node current = (Node)cells.get(j).get(i);
        
        result += "(" + current.getF() + ", " + current.getG() + ", " + current.getH() + ") ";
      }
      
      result += "\n";
    }
    
    return result;
  }
  
  // Permet de créer un mur à la position _i, _j avec une longueur
  // et orientation données.
  void makeWall (int _i, int _j, int _length, boolean _vertical) {
    int max;
    
    if (_vertical) {
      max = _j + _length >= rows ? rows : _j + _length;  
      for (int j = _j; j < max; j++) {
        
        ((Node)cells.get(j).get(_i)).setWalkable (false, 0);
        
      }       
    } else {
      max = _i + _length >= cols ? cols: _i + _length;  
      
      for (int i = _i; i < max; i++) {
        ((Node)cells.get(_j).get(i)).setWalkable (false, 0);
      }     
    }
  }
}
