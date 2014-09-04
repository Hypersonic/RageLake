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
    void execute(World world) {}
    
    // Can this action execute?
    bool canExecute(World world) {
        return true;
    }

}

class MovementAction : Action {
    int x, y;

    this(Entity target, int x, int y) {
        super(target);
        this.x = x;
        this.y = y;
        staminaRequired = 10;
    }

    override void execute(World world) {
        target.stamina -= staminaRequired;
        target.position += Point(x, y);
        super.execute(world);
    }

    override bool canExecute(World world) {
        Point targetPoint = target.position + Point(x, y);
        bool targetClear = true;
        // check if any entities are standing on the target position
        foreach (entity; world.entities) {
            if (entity != target) {
                if (entity.position == targetPoint) {
                    targetClear = false;
                }
            }
        }
        // Check if we have at least staminaRequired stamina
        bool enoughStamina = target.stamina >= staminaRequired;
        return targetClear && enoughStamina;
    }
}
