import std.stdio;
import std.string;
import deimos.ncurses.ncurses;

/*
 * Represents a cell in a terminal-like display.
 * Has a character, a foreground color (the color of the glyph) and a background color (the color of the cell around the glyph) 
 */
struct Cell {
    char glyph;

    this(char glyph) {
        this.glyph = glyph;
    }
}

/*
 * A grid of glyphs
 */
class Display {
    int width, height;

    Cell[][] cells;

    void render() {
        mvprintw(1, 1, toStringz("Hello"));
        refresh();
    }

    this(int width, int height) {
        this.width = width;
        this.height = height;

        foreach (x; 0 .. height) {
            Cell[] row;
            foreach (y; 0 .. width) {
                row ~= Cell('.');
            }
            cells ~= row;
        }
        // init ncurses
        initscr();
    }

    ~this() {
        endwin();
    }
}
