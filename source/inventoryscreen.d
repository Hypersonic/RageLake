import std.string;
import std.conv;
import std.algorithm;
import display;
import screenstack;
import inventory;
import equipment;
import event;
import logger;
import item;

class InventoryScreen : Screen {
    Inventory inventory;
    int selectedItem;
    int selectedList;
    static const int NUM_LISTS = 2;

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
                if (inventory.items.length > 0) {
                    selectedItem++;
                    selectedItem %= inventory.items.length;
                }
                break;
            case 'k':
                if (inventory.items.length > 0) {
                    selectedItem--;
                    if (selectedItem < 0) selectedItem = cast(int) inventory.items.length-1;
                }
                break;
            case 'e':
                auto item = inventory.items[selectedItem];
                if (inventory.items.length > selectedItem && item.canEquip) {
                    if (inventory.equipment.canFind(inventory.items[selectedItem])) {
                        // The item is already equipped, remove it.
                        auto index = inventory.equipment.length - inventory.equipment.find(inventory.items[selectedItem]).length;
                        logInfo("Index: %d", index);
                        inventory.equipment = inventory.equipment.remove(index);
                    } else {
                        inventory.equipment ~= cast(Equipment) inventory.items[selectedItem];
                    }
                }
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
            maxitemwidth = inventory.items.map!(item => item.name.length).reduce!((a, b) => max(a, b)).to!int.max(maxitemwidth) + 10; // pad with at least 10
        int linewidth = maxitemwidth + 4;
        string padding = "".center(linewidth + paddingspace * 2, ' ');
        string invtop = "Inventory".center(linewidth, '-');
        string equiptop = "Equipment".center(linewidth, '-');
        string bottom = "".center(linewidth, '-');
        string side = "|";

        void drawString(int x, int y, string str, bool doPadding = true, Color color = Color.NORMAL) {
            if (doPadding)
                display.drawString(x-paddingspace, y, padding);
            display.drawString(x, y, str, color);
        }

        
        void drawList(string top, Item[] list) {
            y = topY;
            drawString(x, y++, top);
            foreach (i, item; list) {
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
                if (i == selectedItem && list is inventory.items) {
                    color = Color.IMPORTANT;
                    // draw the info for this item
                    

                    auto len = cast(int) max(item.name.length, item.shortDescription.length, item.longDescription.length);

                    // Save teh old padding
                    auto oldpadding = padding;
                    padding = "".center(len + 4 + paddingspace * 2, ' ');
                    scope (exit) padding = oldpadding; // restore it on scope exit

                    auto boxx = 60 - len/2;


                    drawString(boxx, 4, "".center(len+4, '-'));
                    drawString(boxx, 5, side ~ " " ~ item.name.center(len) ~ " " ~ side);
                    drawString(boxx, 6, side ~ " " ~ item.shortDescription.center(len) ~ " " ~ side);
                    drawString(boxx, 7, side ~ " " ~ item.longDescription.center(len) ~ " " ~ side);
                    drawString(boxx, 8, "".center(len+4, '-'));
                    
                }

                drawString(x, y, side ~ " " ~ "".center(maxitemwidth) ~ " " ~ side);
                string suffix = list is inventory.items && inventory.equipment.canFind(item) ? " (e)" : "";
                drawString(x+2, y++, (item.name ~ suffix).center(maxitemwidth), false, color);
            }
            drawString(x, y++, bottom);
            x += linewidth + 2;
            y = topY;

        }

        drawList(equiptop, cast(Item[]) inventory.equipment);

        drawList(invtop, inventory.items);
    }
}
