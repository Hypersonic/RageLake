import display : Display;
import action : Action;
import world : World;

/*
 * Represents a cell in a terminal-like display.
 * Has a character
 * TODO: Add foreground and background colors
 */
struct Cell {
    char glyph;
    Color color = Color.NORMAL;

    this(char glyph) {
        this.glyph = glyph;
    }
}

enum Color {
    NORMAL = 1,
    HEALING,
    TAKING_DAMAGE,
    UNIMPORTANT,
    ENEMY,
    PLAYER
}

struct Point {
    int x, y;
    Point opAdd(Point other) {
        Point p = Point(0, 0);
        p.x = this.x + other.x;
        p.y = this.y + other.y;
        return p;
    }

    Point opAddAssign(Point other) {
        this.x += other.x;
        this.y += other.y;
        return this;
    }

    Point opSub(Point other) {
        return this + (-other);
    }
    
    Point opSubAssign(Point other) {
        this.x -= other.x;
        this.y -= other.y;
        return this;
    }

    Point opUnary(string s)() if (s == "-") {
        return Point(-this.x, -this.y);
    }

    bool opEquals(const Point other) {
        return this.x == other.x && this.y == other.y;
    }
}

unittest {
    Point p1 = Point(0, 0);
    Point p2 = Point(0, 0);
    assert(p1 == p2);

    Point p3 = Point(10, 10);
    assert(p1 + p3 == p3);

    Point p4 = Point(12, 13);
    Point p5 = Point(13, 12);
    assert(p4 + p5 == Point(25, 25));

    p4 += p5;
    assert(p4 == Point(25, 25));

    Point p6 = Point(10, 11);
    assert(-p6 == Point(-10, -11));

    Point p7 = Point(10, 10);
    Point p8 = Point(5, 5);
    assert(p7 - p8 == Point(5,5));

    p7 -= p8;
    assert(p7 == Point(5,5));
}

struct Bounds {
    Point min, max;
    this(Point min, Point max) {
        // Correct min and max if they're not set up so that min is top left and max is bottom right
        if (min.x > max.x) {
            auto tmp = min.x;
            min.x = max.x;
            max.x = tmp;
        }
        if (min.y > max.y) {
            auto tmp = min.y;
            min.y = max.y;
            max.y = tmp;
        }
        this.min = min;
        this.max = max;
    }
    @safe bool contains(Point p) pure {
        return (min.x <= p.x && p.x <= max.x
             && min.y <= p.y && p.y <= max.y);
    }
}

unittest {
    Point p = Point(10, 10);
    
    // Check that the point lies in a bounds it definetly should
    Bounds b = Bounds(Point(0, 0), Point(20, 20));
    assert(b.contains(p));

    // Check that the right edge of a bounds that lies on a point counts as containing it
    Bounds b2 = Bounds(Point(0, 0), Point(10, 10));
    assert(b2.contains(p));

    // Check that the left edge of a bounds that lies on a point counts as containing it
    Bounds b3 = Bounds(Point(10, 10), Point(20, 20));
    assert(b3.contains(p));
    

    // Check that a weird rectangle gets corrected in the constructor so contains still works
    Bounds b4 = Bounds(Point(10, 0), Point(0, 10));
    assert(b4.contains(p));
}

enum EventType {
    RAW_KEY_PRESS,
    KEY_PRESS
}

union DataType {
    char key;
}


struct Event {
    EventType type;
    DataType data;
}

interface Updates {
    // Return the action this thing would like to take
    Action update(World world);
    // Render this thing to the display
    void render(Display display);
}
