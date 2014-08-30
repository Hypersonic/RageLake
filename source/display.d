import std.stdio;
import std.string;
import deimos.ncurses.ncurses;

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

/*
 * A grid of glyphs
 */
class Display {
    int width, height;

    Cell[][] cells;

    void update() {
        foreach (row_i; 0 .. cells.length) {
        foreach (col_i; 0 .. cells[row_i].length) {
            auto cell = cells[row_i][col_i];
            // There's probably a much more efficient way to convert from a character to a c-string
            auto glyph = toStringz("" ~ cell.glyph);
            mvprintw(cast(int)row_i, cast(int)col_i, glyph); // TODO: Add color rendering
        }
        }

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
