import display;
import screenstack;
import inventory;
import event;

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
        foreach (item; inventory.items) {
            display.drawString(x, y++, item.name);
        }
    }
}
