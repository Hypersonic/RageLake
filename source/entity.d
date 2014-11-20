import std.string;
import world : World;
import tile;
import display;
import action : Action;
import util : Cell, Point, Updates, Color;
import event : Event;

class Entity : Updates {
    Point position;
    int stamina;
    int staminaRechargeRate = 4;
    int maxStamina = 100;
    int health = 10;
    int maxHealth = 10;
    bool alive = true;
    Action desiredAction;
    World world;
    Cell cell;
    protected Color normalColor = Color.NORMAL;

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

    void hit(int damage) {
        if (alive) {
            this.cell.color = Color.TAKING_DAMAGE;
            this.health -= damage;
            if (this.health <= 0) {
                this.die();
            }
        }
    }

    void die() {
        alive = false;
        normalColor = Color.UNIMPORTANT;
    }

    Action update(World world) {
        // Recharge stamina
        stamina += staminaRechargeRate;
        if (stamina > maxStamina) stamina = maxStamina;
        if (this.stamina == this.maxStamina) cell.color = normalColor;
        return new Action(this);
    }

    bool canTraverse(Tile tile) {
        return typeid(tile) == typeid(FloorTile);
    }

    void render(Display display) {
        if (display.viewport.contains(this.position)) {
            display.drawCell(this.position, this.cell);
        }
    }
}
