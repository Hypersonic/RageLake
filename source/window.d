import std.string;
import std.algorithm;

import display;

class Window {
    string[] lines;
    
    this() {}

    void push(string rhs) {
        lines ~= rhs;
    }

    void render(Display display, int x, int y) {
        int width = cast(int) lines.map!(a => a.length).reduce!max;
        string padding = "".center(width + 6);
        display.drawString(x - 1, y, padding);
        display.drawString(x, y, "".center(width + 4, '-'));
        y++;
        foreach (line; lines) {
            display.drawString(x - 1, y, padding);
            display.drawString(x, y, "| " ~ line.center(width) ~ " |");
            y++;
        }
        display.drawString(x - 1, y, padding);
        display.drawString(x, y, "".center(width + 4, '-'));
    }
}
