// Cell class for using canvas as grid.
public class Cell {
    public boolean[] walls;		// Wall array that holds wall values. false means wall removed.
    public boolean visited = false;

    int ix;		// X index on grid array.
    int iy;		// Y index on grid array.

    int x;		// X location.
    int y;		// Y location.
    int s;		// Square size. 

    /* Corner calculation from coordinates. (XY: Center of the square.)
     	TopLeft: (x-s/2), (y-s/2)
     	TopRight: (x+s/2), (y-s/2)
     	BottomRight: (x+s/2), (y+s/2)
     	BottomLeft: (x-s/2), (y+s/2)
     	*/

    // Cell constructor.
    Cell(int x, int y, int s, int ix, int iy) {
        this.x = x;
        this.y = y;
        this.s = s;
        this.ix = ix;
        this.iy = iy;

        walls = new boolean[4];
        for (int w=0; w<walls.length; w++) {
            walls[w] = true;	// All walls are exist on start.
        }
    }

    // Draws the box.
    void show(int c) {
        // Color depends on being current, generated or blank area.
        if (c == 0) {
            stroke(0, 0, 255);		// Blue for current.
            strokeWeight(5);
        } else if (c == 1) {
            stroke(0, 255, 0);	// Green for generated.
            strokeWeight(3);
        } else {
            stroke(0);			// Black for blank.
            strokeWeight(1);
        }

        // Draw the box line by line.
        if (walls[0]) {
            line((x-s/2), (y-s/2), (x+s/2), (y-s/2));	// Top left corner -> Top right corner.
        }
        if (walls[1]) {
            line((x+s/2), (y-s/2), (x+s/2), (y+s/2));	// Top right corner -> Bottom right corner.
        }
        if (walls[2]) {
            line((x+s/2), (y+s/2), (x-s/2), (y+s/2));	// Bottom right corner -> Bottom left corner.
        }
        if (walls[3]) {
            line((x-s/2), (y+s/2), (x-s/2), (y-s/2));	// Bottom left corner -> Top left corner.
        }
    }
}
