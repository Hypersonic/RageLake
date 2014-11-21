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
    this(Inventory inventory) {
        this.inventory = inventory;
        inputFallthrough = false;
        isTransparent = false;
    }

    override void takeInput(KeyPress kp) {
        switch (kp.key) {
            case 127: // Backspace
            case 27: // ESC
            case 'q':
                import app;
                screens.pop();
                break;
            default:
                break;
        }
    }

    override void render(Display display) {
        int x = 10;
        int y = 10;
        int maxitemwidth = 20;
        // find the largest width. If it's less than maxitemwidth's value, use that instead
        if (inventory.items.length > 0)
            maxitemwidth = inventory.items.map!(item => item.name.length)().reduce!((a, b) => max(a, b))().to!int.max(maxitemwidth);
        string top    = "Inventory".center(maxitemwidth + 4, '-');
        string bottom = "".center(maxitemwidth + 4, '-');
        string side = "|";
        display.drawString(x, y++, top);
        foreach (item; inventory.items) {
            // If we've hit the bottom, finish our border, move back to the top and over to the right a bit, and start a new border
            if (y >= display.height) {
                display.drawString(x, y++, bottom);
                y = 10;
                x += maxitemwidth + 6;
                display.drawString(x, y++, top);
            }
            display.drawString(x, y++, side ~ " " ~ item.name.center(maxitemwidth) ~ " " ~ side);
        }
        display.drawString(x, y++, bottom);
    }
}
