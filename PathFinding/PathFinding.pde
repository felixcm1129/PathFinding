NodeMap worldMap; //<>//

int deltaTime = 0;
int previousTime = 0;

int mapRows = 10;
int mapCols = 10;

Matrix matrix;

ArrayList<ArrayList<Cell>> start_end;

color baseColor = color (0, 127, 0);

void setup () {
  size (1200, 720);
  //fullScreen();
  
  initMap();
}

void draw () {
  deltaTime = millis () - previousTime;
  previousTime = millis();
  
  update(deltaTime);
  display();
}

void update (float delta) {
  worldMap.update(delta);
}

void display () {
  
  if (worldMap.path != null) {
    for (Cell c : worldMap.path) {
      c.setFillColor(color (125, 0, 0));
    }
  }
  
  worldMap.display();
} //<>//

void initMap () {
  worldMap = new NodeMap (mapRows, mapCols); 
  
  worldMap.setBaseColor(baseColor);
  
  int randomsWall_lenght1 = int(random(mapCols/3, mapCols - 1));
  int randomsWall_lenght2 = int(random(mapRows/10, mapRows /2));
  
  int randomsStartX1;
  int randomsStartY1;
  int randomsEndX1;
  int randomsEndY1;
  
  worldMap.makeWall (mapCols / 2, 0, randomsWall_lenght1, true);
  worldMap.makeWall (mapCols / 2, int(random(0, mapCols)), randomsWall_lenght2, false);;
  
  do{
  
    randomsStartX1 = int(random(0, mapCols));
    randomsStartY1 = int(random(0, mapRows));
    randomsEndX1 = int(random(0, mapCols));
    randomsEndY1 = int(random(0, mapRows));
    
    worldMap.setStartCell(randomsStartX1,randomsStartY1);
    worldMap.setEndCell(randomsEndX1,randomsEndY1); 
    
  }while(!(worldMap.getstartCelliswalkable(randomsStartX1, randomsStartY1)) || !(worldMap.getendCelliswalkable(randomsEndX1, randomsEndY1)));   
  
  worldMap.updateHs();
    
  worldMap.generateNeighbourhood();
      
  worldMap.findAStarPath();
}

void keyReleased()
{
  if(key == 'r')
  {
    setup();
  }
}
