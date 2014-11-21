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

    // TODO: Add scrolling if we have more items than we can fit onscreen
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
            if (y < display.height) // Only draw up to the height of the screen.
                display.drawString(x, y++, side ~ " " ~ item.name.center(maxitemwidth) ~ " " ~ side);
        }
        display.drawString(x, y++, bottom);
    }
}
