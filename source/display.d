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
        foreach (row_i; 0 .. cells.length) {
        foreach (col_i; 0 .. cells[row_i].length) {
            auto cell = cells[row_i][col_i];
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
