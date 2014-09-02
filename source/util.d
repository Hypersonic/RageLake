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
    @safe bool contains(Point p) pure {
        return (min.x <= p.x && p.x < max.x
             && min.y <= p.y && p.y < max.y);
    }
}

struct KeyState {
    int keyCode;
    bool pressed;
}

enum EventType {
    KEY_PRESS
}
enum KeyType {
    MOVE_LEFT,
    MOVE_RIGHT,
    MOVE_UP,
    MOVE_DOWN,
    QUIT,
    NONE
}

interface Updates {
    void update(World world);
    void render(Display display);
}
