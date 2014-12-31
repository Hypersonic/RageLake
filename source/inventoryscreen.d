import std.string;
import std.conv;
import std.algorithm;
import display;
import window;
import screenstack;
import inventory;
import equipment;
import event;
import logger;
import item;
import util;

class InventoryScreen : Screen {
    Inventory inventory;
    int selectedItem;

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
                selectedItem++;
                selectedItem = wrap(selectedItem, 0, inventory.items.length.to!int - 1);
                break;
            case 'k':
                selectedItem--;
                selectedItem = wrap(selectedItem, 0, inventory.items.length.to!int - 1);
                break;
            case 'e':
                if (inventory.items.length == 0) break;
                auto item = inventory.items[selectedItem];
                if (inventory.items.length > selectedItem && item.isA!Equipment) {
                    if (inventory.equipment.canFind(inventory.items[selectedItem])) {
                        // The item is already equipped, remove it.
                        inventory.unequip(inventory.items[selectedItem]);
                    } else {
                        inventory.equip(inventory.items[selectedItem]);
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
        int maxitemwidth = 20;
        // find the largest width. If it's less than maxitemwidth's value, use that instead
        if (inventory.items.length > 0)
            maxitemwidth = inventory.items.map!(item => item.name.length).reduce!((a, b) => max(a, b)).to!int.max(maxitemwidth) + 10; // pad with at least 10
        int linewidth = maxitemwidth;
        string invtop = "Inventory";
        string equiptop = "Equipment";

        void drawList(string title, Item[] list) {
            y = topY;
            Window win = new Window(title);
            int maxWindowHeight = display.height - topY * 2;
            int maxdistfromtop = maxWindowHeight / 2;
            int maxdistfrombottom = maxWindowHeight / 2;
            int start_idx = 0, end_idx = list.length.to!int;
            if (list is inventory.items) {
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
                if (i+start_idx == selectedItem && list is inventory.items) {
                    color = Color.IMPORTANT;
                    // draw the info for this item
                    
                    Window itemInfo = new Window("Item info");

                    auto boxx = x + win.width + 6;
 
                    int line = cast(int) (i + topY);

                    itemInfo.push(item.name);
                    itemInfo.push(item.shortDescription);
                    itemInfo.push(item.longDescription);
                    // Draw info specific to equipment
                    if (item.isA!Equipment) {
                        auto itemEquip = cast(Equipment) item;
                        const string[] conditions = ["Broken", "Falling apart", "Slightly damaged", "Fine"];
                        auto condition = conditions[((conditions.length - 1) * itemEquip.durability) / itemEquip.maxDurability];
                        auto condstr = "Condition: " ~ condition ~ " (%s / %s)".format(itemEquip.durability, itemEquip.maxDurability);
                        itemInfo.push(condstr);
                        itemInfo.push("Equip Regions: %s".format(itemEquip.regions));
                    }

                    itemInfo.render(display, boxx, line);
                    
                }

                string suffix = (list is inventory.items && inventory.equipment.canFind(item)
                                ? " (equipped)" : "");
                win.push(item.name ~ suffix, color);
            }
            win.render(display, x, y);
            x += win.width + 6;
        }

        drawList(equiptop, cast(Item[]) inventory.equipment);

        drawList(invtop, inventory.items);
    }
}
