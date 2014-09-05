import std.stdio;
import std.string;
import std.signals;
import deimos.ncurses.ncurses;
import world : World;
import util : Cell, Point, Bounds;


/*
 * A grid of glyphs
 */
class Display {
    int width, height;
    string[] debugmsgs;
    Bounds viewport;

    void update(ref World world) {
        erase();
        foreach (i; 0 .. width) {
            foreach (j; 0 .. height) {
                drawCell(Point(i, j), Cell('.'));
            }
        }
        foreach (entity; world.entities) {
            if (viewport.contains(entity.position)) {
                entity.render(this);
            }
        }
        emit(this); // At this point, anything can hook in by registering for events from display
        // Render debug messages
        auto i = 0;
        foreach (msg; debugmsgs) {
            i++;
            mvprintw(i, 0, toStringz(msg));
        }
        debugmsgs.clear();

        refresh();
    }
    mixin Signal!(Display);

    void drawString(int x, int y, string str) {
        mvprintw(y, x, toStringz(str));
    }

    void drawCell(Point position, Cell cell) {
        // There's probably a much more efficient way to convert from a character to a c-string
        auto glyph = toStringz("" ~ cell.glyph);
        mvprintw(position.y - viewport.min.y, position.x - viewport.min.x, glyph);
    }
    
    void drawDebugMessage(string str) {
        debugmsgs ~= str;
    }

    this(int width, int height, Bounds view) {
        this.width = width;
        this.height = height;
        this.viewport = view;

        // init ncurses
        initscr();
        cbreak();
        noecho();
        nonl();
        nodelay(stdscr, true);
        intrflush(stdscr, false);
        keypad(stdscr, true);
    }

    ~this() {
        endwin();
    }
}
