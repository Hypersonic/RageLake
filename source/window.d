import std.string;
import std.algorithm;
import std.typecons;

import display;

enum Alignment {
    ALIGN_LEFT,
    ALIGN_CENTER,
    ALIGN_RIGHT
}

class Window {
    string title;
    Tuple!(string, Color, Alignment)[] lines;
    
    this(string title = "") {
        this.title = title;
    }

    void push(string rhs, Color color = Color.NORMAL, Alignment alignment = Alignment.ALIGN_CENTER) {
        lines ~= tuple(rhs, color, alignment);
    }

    int width() {
        import std.array;
        return cast(int) (lines.map!(a => a[0]).map!(a => a.length).array ~ title.length ~ 30L).reduce!max;
    }
    
    int height() {
        return cast(int) lines.length + 2; // 2 for title and underline
    }

    void render(Display display, int x, int y) {
        int width = this.width;
        string padding = "".center(width + 6);
        display.drawString(x - 1, y, padding);
        display.drawString(x, y, "+" ~ title.center(width + 2, '-') ~ "+");
        y++;
        foreach (line; lines) {
            string alignedstring;
            switch (line[2]) {
                case Alignment.ALIGN_LEFT:
                    alignedstring = line[0].leftJustify(width);
                    break;
                case Alignment.ALIGN_CENTER:
                    alignedstring = line[0].center(width);
                    break;
                case Alignment.ALIGN_RIGHT:
                    alignedstring = line[0].rightJustify(width);
                    break;
                default:
                    break;
            }
            display.drawString(x - 1, y, padding);
            display.drawString(x, y, "| ");
            display.drawString(x+2, y, alignedstring, line[1]);
            display.drawString(x+2+width, y, " |");
            y++;
        }
        display.drawString(x - 1, y, padding);
        display.drawString(x, y, "+" ~ "".center(width + 2, '-') ~ "+");
    }
}
