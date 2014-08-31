import std.stdio;
import std.string;
import deimos.ncurses.ncurses;
import world : World;
import util : Cell, Point, Bounds;


/*
 * A grid of glyphs
 */
class Display {
    int width, height;
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
        refresh();
    }

    void drawCell(Point position, Cell cell) {
        // There's probably a much more efficient way to convert from a character to a c-string
        auto glyph = toStringz("" ~ cell.glyph);
        mvprintw(position.y - viewport.min.y, position.x - viewport.min.x, glyph);
    }
    
    void drawDebugMessage(string str) {
        mvprintw(height, 0, toStringz(str));
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
        //intrflush(stdscr, false);
        keypad(stdscr, true);
    }

    ~this() {
        endwin();
    }
}
