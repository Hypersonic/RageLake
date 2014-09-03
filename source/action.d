import world;
import entity;

// The vanilla action is abstract, all actual actions should be subclasses
class Action {
    Entity target;
    int staminaRequired;

    this(Entity target) {
        this.target = target;
    }

    // Execute this action in the given world
    void execute(World w) {}

}

class MovementAction : Action {
    int x, y;

    this(Entity target, int x, int y) {
        super(target);
        this.x = x;
        this.y = y;
        staminaRequired = 10;
    }

    override void execute(World w) {
        if (target.stamina >= staminaRequired) {
            target.stamina -= staminaRequired;
            target.position.x += x;
            target.position.y += y;
        }
        super.execute(w);
    }
}
