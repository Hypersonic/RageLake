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
        int maxitemwidth = 20;
        // find the largest width. If it's less than maxitemwidth's value, use that instead
        if (inventory.items.length > 0)
            maxitemwidth = inventory.items.map!(item => item.name.length).reduce!((a, b) => max(a, b)).to!int.max(maxitemwidth) + 10; // pad with at least 10
        int linewidth = maxitemwidth;
        string invtop = "Inventory";
        string equiptop = "Equipment";

        void drawList(string top, Item[] list) {
            y = topY;
            Window win = new Window(top);
            foreach (i, item; list) {
                // If we've hit the bottom, finish our border, move back to the top and over to the right a bit, and start a new border
                auto color = Color.NORMAL;
                if (i == selectedItem && list is inventory.items) {
                    color = Color.IMPORTANT;
                    // draw the info for this item
                    
                    Window itemInfo = new Window("Item info");

                    auto boxx = x + win.width + 6;

                    int line = topY;

                    itemInfo.push(item.name);
                    itemInfo.push(item.shortDescription);
                    itemInfo.push(item.longDescription);
                    // Draw info specific to equipment
                    if (item.canEquip()) {
                        auto itemEquip = cast(Equipment) item;
                        const string[] conditions = ["Broken", "Falling apart", "Slightly damaged", "Fine"];
                        auto condition = conditions[((conditions.length - 1) * itemEquip.durability) / itemEquip.maxDurability];
                        auto condstr = "Condition: " ~ condition ~ " (%s / %s)".format(itemEquip.durability, itemEquip.maxDurability);
                        itemInfo.push(condstr);
                    }

                    itemInfo.render(display, boxx, line);
                    
                }

                string suffix = list is inventory.items && inventory.equipment.canFind(item) ? " (e)" : "";
                win.push(item.name ~ suffix, color);
            }
            win.render(display, x, y);
            x += win.width + 6;
        }

        drawList(equiptop, cast(Item[]) inventory.equipment);

        drawList(invtop, inventory.items);
    }
}
