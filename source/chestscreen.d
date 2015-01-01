import std.conv;
import std.string;
import std.algorithm;

import screenstack;
import inventory;
import item;
import window;
import display;
import event;
import util;

class ChestScreen : Screen {
    Inventory opener, opened;
    int selectedItem;
    Inventory selectedInventory;

    this(Inventory opener, Inventory opened) {
        this.opener = opener;
        this.opened = opened;

        this.selectedInventory = this.opener;

        this.isTransparent = false;
        this.inputFallthrough = false;
    }

    override void takeInput(KeyPress kp) {
        switch (kp.key) {
            case 127: // Backspace
            case 27: // ESC
            case 'q':
                import app;
                screens.pop();
                break;
            case 't':
                // Take all items from chest
                foreach (item; opened.items) {
                    opener.items ~= item;
                }
                opened.items = [];
                break;
            case 'j':
                selectedItem++;
                selectedItem = wrap(selectedItem, 0, selectedInventory.items.length.to!int - 1);
                break;
            case 'k':
                selectedItem--;
                selectedItem = wrap(selectedItem, 0, selectedInventory.items.length.to!int - 1);
                break;
            case 'l':
            case 'h':
                if (selectedInventory is opener) {
                    selectedInventory = opened;
                } else {
                    selectedInventory = opener;
                }
                selectedItem = wrap(selectedItem, 0, selectedInventory.items.length.to!int - 1);
                break;
            default:
                break;
        }
    }

    override void render(Display display) {
        int topY = 10;
        int y = 10;
        int x = 10;

        void drawList(string title, Item[] list) {
            y = topY;
            Window win = new Window(title);
            int maxWindowHeight = display.height - topY * 2;
            int maxdistfromtop = maxWindowHeight / 2;
            int maxdistfrombottom = maxWindowHeight / 2;
            int start_idx = 0, end_idx = list.length.to!int;
            if (list is selectedInventory.items) {
                // Allow scrolling through the list
                start_idx = max(0, selectedItem - maxdistfromtop);
                if (list.length >= start_idx + maxWindowHeight) {
                    // We're not yet hitting the end of the list, so just offset the end by maxWindowHeight
                    end_idx = start_idx + maxWindowHeight;
                } else {
                    // We're near the end of the list, put the end_idx at the end of the list, and push the start_idx down by maxWindowHeight, to a minimum of zero 
                    end_idx = list.length.to!int;
                    start_idx = max(0, end_idx - maxWindowHeight);
                }
            }
            foreach (i, item; list[start_idx .. end_idx]) {
                if (topY + i > display.height - topY) break;
                // If we've hit the bottom, finish our border, move back to the top and over to the right a bit, and start a new border
                auto color = Color.NORMAL;
                if (i+start_idx == selectedItem && list is selectedInventory.items) {
                    color = Color.IMPORTANT;
                }

                win.push(item.name, color);
            }
            win.render(display, x, y);
            x += win.width + 6;
        }

        drawList("Your Inventory", opener.items);
        drawList("Chest", opened.items);

    }
}
