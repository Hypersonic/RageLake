import std.stdio;
import std.string;
import std.signals;
import deimos.ncurses.ncurses;
import world : World;
import util : Cell, Point, Bounds, Color;

class Display {
    int width, height;
    string[] debugmsgs;
    Bounds viewport;

    void update(ref World world) {
        // Get the window bounds
        getmaxyx(stdscr, this.height, this.width);

        erase();

        // Draw background grid
        {
            attron(COLOR_PAIR(Color.NORMAL));
            scope (exit) attroff(COLOR_PAIR(Color.NORMAL));
            foreach (i; 0 .. width) {
                foreach (j; 0 .. height) {
                    auto p = Point(i, j);
                    if (viewport.contains(p)) {
                        drawCell(p, Cell('.'));
                    }
                }
            }
        }

        foreach (entity; world.entities) {
            if (viewport.contains(entity.position)) {
                entity.render(this);
            }
        }
        emit(this); // At this point, anything can hook in by registering for events from display
        drawDebugMessage(format("Width: %d", width));
        drawDebugMessage(format("Height: %d", height));
        // Render debug messages
        auto i = 0;
        foreach (msg; debugmsgs) {
            drawString(0, i, msg);
            i++;
        }
        debugmsgs.clear();

        refresh();
    }
    mixin Signal!(Display);

    void drawString(int x, int y, string str, Color color = Color.NORMAL) {
        attron(COLOR_PAIR(color));
        scope (exit) attroff(COLOR_PAIR(color));
        mvprintw(y, x, toStringz(str));
    }

    void drawCell(Point position, Cell cell) {
        // There's probably a much more efficient way to convert from a character to a c-string
        auto glyph = toStringz("" ~ cell.glyph);
        attron(COLOR_PAIR(cell.color));
        scope (exit) attroff(COLOR_PAIR(cell.color));
        mvprintw(position.y - viewport.min.y, position.x - viewport.min.x, glyph);
    }
    
    void drawDebugMessage(string str) {
        debugmsgs ~= str;
    }

    this(Bounds view) {
        this.viewport = view;

        // init ncurses
        initscr();
        start_color();
        cbreak();
        noecho();
        nonl();
        nodelay(stdscr, true);
        intrflush(stdscr, false);
        keypad(stdscr, false);

        // Get the window bounds
        getmaxyx(stdscr, this.height, this.width);
        writeln(); // Writeln to flush buffers

        init_pair(Color.NORMAL, COLOR_WHITE, COLOR_BLACK);
        init_pair(Color.HEALING, COLOR_GREEN, COLOR_BLACK);
        init_pair(Color.TAKING_DAMAGE, COLOR_WHITE, COLOR_RED);
        init_pair(Color.UNIMPORTANT, COLOR_WHITE, COLOR_BLACK);
        init_pair(Color.ENEMY, COLOR_RED, COLOR_BLACK);
        init_pair(Color.PLAYER, COLOR_GREEN, COLOR_BLACK);
    }

    ~this() {
        endwin();
    }
}
