import world;
import entity;

class Action {
    Entity target;
    int staminaRequired;
    Action alternate; // An alternate action that can be attempted if this one cannot execute

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
        // If we the target spot is taken, set our alternate action
        if (!targetClear)
            this.alternate = new AttackAction(target, x, y);
        return targetClear && enoughStamina;
    }
}

class AttackAction : Action {
    int x, y;

    this(Entity target, int x, int y) {
        super(target);
        this.x = x;
        this.y = y;
        staminaRequired = 10;
    }
    
    override void execute(World world) {
        target.stamina -= staminaRequired;
        Entity entAtLocation;
        Point location = target.position + Point(x, y);
        foreach (entity; world.entities) {
            if (entity.position == location) {
                entAtLocation = entity;
            }
        }
        if (entAtLocation) {
            entAtLocation.hit(1); // Do 1 damage to the target
        }
    }

    override bool canExecute(World world) {
        return target.stamina >= staminaRequired; // All we need is enough stamina
    }
}
