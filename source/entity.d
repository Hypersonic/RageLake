import world : World;
import display : Display;
import util : Cell, Point, Updates, KeyState;

class Entity : Updates {
    Point position;
    int stamina;
    int staminaRechargeRate = 10;
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

    void update(KeyState keyState, World world) {
    }

    void render(Display display) {
        display.drawCell(this.position, this.cell);
    }

    // Do any setup required to step before any entities step
    void preStep() {
    }
    // Step forward in time in the given world
    void step() {
    }
    // Cleanup after stepping
    void postStep() {
        // Recharge stamina
        stamina += staminaRechargeRate;
        if (stamina > maxStamina) stamina = maxStamina;
    }
}
