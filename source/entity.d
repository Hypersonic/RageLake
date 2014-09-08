import std.string;
import world : World;
import display : Display;
import action : Action;
import util : Cell, Point, Updates, Event, Color;

class Entity : Updates {
    Point position;
    int stamina;
    int staminaRechargeRate = 4;
    int maxStamina = 100;
    int health = 10;
    int maxHealth = 10;
    Action desiredAction;
    World world;
    Cell cell;
    Color normalColor = Color.NORMAL;

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

    void hit(int damage) {
        this.cell.color = Color.TAKING_DAMAGE;
        this.health -= damage;
        if (this.health <= 0) {
            this.die();
        }
    }

    void die() {
        normalColor = Color.UNIMPORTANT;
    }

    Action update(World world) {
        // Recharge stamina
        stamina += staminaRechargeRate;
        if (stamina > maxStamina) stamina = maxStamina;
        if (this.stamina == this.maxStamina) cell.color = normalColor;
        return new Action(this);
    }

    void render(Display display) {
        display.drawCell(this.position, this.cell);
    }

}
