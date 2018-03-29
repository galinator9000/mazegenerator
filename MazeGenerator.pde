// Maze generation with Recursive Backtracker Algorithm.
// Algorithm source: https://en.wikipedia.org/wiki/Maze_generation_algorithm
// The Coding Train's video about algorithm: https://www.youtube.com/watch?v=HyK_Q5rrcr4 

Cell[][] Cells;		// Main 2D cell array for holding cell objects.
Cell[] Stack;		// Stack traces visited cells.

Cell[] neighbors;	// Current neighbor cell objects will be kept on this array. (Top, right, bottom, left)
Cell neighbor;		// Random selected neighbor cell object.
Cell current;		// Current cell object.

final int bgColor = 30;		// Background color.
int rows;
int cols;
int res = 40;	// Resolution.

int curX;    	// Current cell object's X location in array.
int curY;    	// Current cell object's Y location in array.

void setup(){
	size(800, 800);		// Keep window size square if possible.

	rows = height / res;	// Calculate row count.
	cols = width / res;		// Calculate column count.

	Cells = new Cell[rows][cols];
	Stack = new Cell[rows*cols];

	neighbors = new Cell[4];

	// Create our cell objects and put them in array.
	for(int x=0; x<Cells.length; x++){
		for(int y=0; y<Cells[x].length; y++){
			Cells[x][y] = new Cell(x*res+(res/2), y*res+(res/2), res, x, y);
		}
	}
	curX = 0;
	curY = 0;

	println("Generating..");
}

void draw(){
	background(bgColor);		// Clear screen.
	
	// Push the current cell, for tracing.
	current = Cells[curX][curY];
	PushCell(current);

	// Mark current cell as visited.
	current.visited = true;

	// Draw the whole maze.
	drawMaze();

	// If any neighbors not available.
	if(!checkNeighbors()){
		println("Stuck!");
		// Take a step back, and see if that cell object has available neighbors.
		do{
    		Cell c = PopCell();		// Take a step back.
			if(c == null){			// If stack is empty, that means Maze is DONE!
				println("DONE!");
				drawLastTime();		// Draw all maze for last time.
				noLoop();			// Do not call draw function again.
				return;
    		}else{
				println("Backtracing..");
    			curX = c.ix;	// Make the previous cell current cell. We stepped back.
    			curY = c.iy;
    		}
		}while(!checkNeighbors());		// If we cannot find any neighbors in current cell, take one more step.
	}

	// Select a random neighbor from available neighbors.
	do{
		int rn = int(random(0, neighbors.length));
		neighbor = neighbors[rn];
	}while(neighbor == null);

	// Remove the walls between neighbor cell and current cell.
	if(neighbor.ix > curX){			// Neighbor on our right.
		current.walls[1] = false;
		neighbor.walls[3] = false;
	}else if(neighbor.ix < curX){	// Neighbor on our left.
        current.walls[3] = false;
        neighbor.walls[1] = false;
    }else if(neighbor.iy > curY){	// Neighbor on our bottom.
        current.walls[2] = false;
        neighbor.walls[0] = false;
    }else if(neighbor.iy < curY){	// Neighbor on our top.
        current.walls[0] = false;
        neighbor.walls[2] = false;
    }

	curX = neighbor.ix;		// Make the neighbor cell current object.
	curY = neighbor.iy;
	current = Cells[curX][curY];
}

// Check available neighbors.
boolean checkNeighbors(){
	boolean availableNeighbors;		// Variable for holding if we found any available neighbor or not.

    for(int n=0; n<neighbors.length; n++){
        neighbors[n] = null;	// Make all neighbors null before scanning.
    }

	// Extra if statements are for checking edges of the window.

    availableNeighbors = false;
    if(curY-1>=0 && curY-1<cols){
        if(!Cells[curX][curY-1].visited){		// Is top neighbor available?
            neighbors[0] = Cells[curX][curY-1];
            availableNeighbors = true;
        }
    }
    if(curX+1>=0 && curX+1<rows){
        if(!Cells[curX+1][curY].visited){		// Is right neighbor available?
            neighbors[1] = Cells[curX+1][curY];
            availableNeighbors = true;
        }
    }
    if(curY+1>=0 && curY+1<cols){
        if(!Cells[curX][curY+1].visited){		// Is bottom neighbor available?
            neighbors[2] = Cells[curX][curY+1];
            availableNeighbors = true;
        }
    }
    if(curX-1>=0 && curX-1<rows){
        if(!Cells[curX-1][curY].visited){		// Is left neighbor available?
            neighbors[3] = Cells[curX-1][curY];
            availableNeighbors = true;
        }
    }

	return availableNeighbors;
}

// Pop cell object from array.
Cell PopCell(){
	int i = StackAvailable();
	Cell r;

    if(i != -1 && i != 0){
		r = Stack[i-1];
		Stack[i-1] = null;
		return r;
    }
	return null;
}

// Push cell object to array.
void PushCell(Cell cell){
	int i = StackAvailable();

	if(i != -1){
		Stack[i] = cell;
	}
}

// Check stack's last available spot.
int StackAvailable(){
	for(int s=0; s<Stack.length; s++){
		if(Stack[s] == null){
			return s;
		}
	}
	return -1;
}

// Draw Maze.
void drawMaze(){
	// Draw all cell objects.
    for(int x=0; x<Cells.length; x++){
        for(int y=0; y<Cells[x].length; y++){
            if(x == curX && y == curY){        // If it is current, draw it is as blue.
                Cells[x][y].show(0);
            }else if(Cells[x][y].visited){    // If it is visited, draw it is as green.
                Cells[x][y].show(1);
            }else{
                Cells[x][y].show(2);        // If it is not visited, draw it is as black.
            }
        }
    }
}

// Draws all cell objects with green color.
void drawLastTime(){
	background(bgColor);

	// Draw all cell objects.
    for(int x=0; x<Cells.length; x++){
        for(int y=0; y<Cells[x].length; y++){
			Cells[x][y].show(1);
        }
    }
}
