import std.string;
import world : World;
import display : Display;
import util : Cell, Point, Updates, RecievesKeys, KeyType;

class Entity : Updates, RecievesKeys {
    Point position;
    int stamina;
    int staminaRechargeRate = 3;
    int maxStamina = 100;
    World world;
    Cell cell;

    this(World world) {
        this.world = world;
        this.position = Point(0, 0);
        this.cell = Cell('c');
        stamina = maxStamina;
    }

    this(World world, Point p) {
        this(world);
        this.position = p;
    }

    void recieveKey(KeyType type) {
    }

    void update(World world) {
        // Recharge stamina
        stamina += staminaRechargeRate;
        if (stamina > maxStamina) stamina = maxStamina;
    }

    void render(Display display) {
        display.drawCell(this.position, this.cell);
    }

}
