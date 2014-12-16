import std.string;
import std.algorithm;
import std.typecons;

import display;

class Window {
    string title;
    Tuple!(string, Color)[] lines;
    
    this(string title = "") {
        this.title = title;
    }

    void push(string rhs, Color color = Color.NORMAL) {
        lines ~= tuple(rhs, color);
    }

    int width() {
        return cast(int) reduce!max(title.length, lines.map!(a => a[0]).map!(a => a.length)) + 20;
    }

    void render(Display display, int x, int y) {
        int width = this.width - 6;
        string padding = "".center(width + 6);
        display.drawString(x - 1, y, padding);
        display.drawString(x, y, title.center(width + 4, '-'));
        y++;
        foreach (line; lines) {
            display.drawString(x - 1, y, padding);
            display.drawString(x, y, "| ");
            display.drawString(x+2, y, line[0].center(width), line[1]);
            display.drawString(x+2+width, y, " |");
            y++;
        }
        display.drawString(x - 1, y, padding);
        display.drawString(x, y, "".center(width + 4, '-'));
    }
}
