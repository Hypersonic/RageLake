import display : Display;
import world : World;

/*
 * Represents a cell in a terminal-like display.
 * Has a character
 * TODO: Add foreground and background colors
 */
struct Cell {
    char glyph;

    this(char glyph) {
        this.glyph = glyph;
    }
}

struct Point {
    int x, y;
}

struct Bounds {
    Point min, max;
    bool contains(Point p) {
        return (min.x <= p.x && p.x < max.x
             && min.y <= p.y && p.y < max.y);
    }
}

struct KeyState {
    int keyCode;
    bool pressed;
}

interface Updates {
    void update(KeyState keyState, World world);
    void render(Display display);
}
