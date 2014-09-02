import std.string;
import world : World;
import display : Display;
import util : Cell, Point, Updates, KeyType, EventType, Event;

class Entity : Updates {
    Point position;
    int stamina;
    int staminaRechargeRate = 4;
    int maxStamina = 100;
    World world;
    Cell cell;

    this(World world) {
        this.world = world;
        this.position = Point(0, 0);
        this.cell = Cell('c');
        stamina = maxStamina;
        world.game.connect(&this.watch);
    }

    this(World world, Point p) {
        this(world);
        this.position = p;
    }

    void watch(Event event) {
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
