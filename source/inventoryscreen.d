import std.string;
import std.conv;
import std.algorithm;
import display;
import screenstack;
import inventory;
import event;
import logger;

class InventoryScreen : Screen {
    Inventory inventory;
    int selected;

    this(Inventory inventory) {
        this.inventory = inventory;
        inputFallthrough = false;
        isTransparent = true;
    }

    override void takeInput(KeyPress kp) {
        switch (kp.key) {
            case 127: // Backspace
            case 27: // ESC
            case 'q':
            case 'i':
                import app;
                screens.pop();
                break;
            // Allow scrolling through the items list, wrap at edges
            case 'j':
                selected++;
                selected %= inventory.items.length;
                break;
            case 'k':
                selected--;
                if (selected < 0) selected = cast(int) inventory.items.length-1;
                break;
            default:
                break;
        }
    }

    override void render(Display display) {
        int x = 10;
        int topY = 10;
        int y = topY;
        int paddingspace = 1;
        int maxitemwidth = 20;
        // find the largest width. If it's less than maxitemwidth's value, use that instead
        if (inventory.items.length > 0)
            maxitemwidth = inventory.items.map!(item => item.name.length)().reduce!((a, b) => max(a, b))().to!int.max(maxitemwidth);
        int linewidth = maxitemwidth + 4;
        string padding = "".center(linewidth + paddingspace * 2, ' ');
        string top    = "Inventory".center(linewidth, '-');
        string bottom = "".center(linewidth, '-');
        string side = "|";

        void drawString(int x, int y, string str, bool doPadding = true, Color color = Color.NORMAL) {
            if (doPadding)
                display.drawString(x-paddingspace, y, padding);
            display.drawString(x, y, str, color);
        }

        drawString(x, y++, top);
        foreach (i, item; inventory.items) {
            // If we've hit the bottom, finish our border, move back to the top and over to the right a bit, and start a new border
            if (y >= display.height) {
                drawString(x, y++, bottom);
                y = topY;
                x += linewidth + 2;
                // Stop if there is no more horizontal room
                if (x + linewidth + paddingspace * 2 > display.width) 
                    return;
                drawString(x, y++, top);
            }

            auto color = Color.NORMAL;
            if (i == selected) {
                color = Color.IMPORTANT;
            }

            drawString(x, y, side ~ " " ~ "".center(maxitemwidth) ~ " " ~ side);
            drawString(x+2, y++, item.name.center(maxitemwidth), false, color);
        }
        drawString(x, y++, bottom);
    }
}
