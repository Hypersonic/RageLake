import world;
import entity;
import event : Movement;
import tile;
import logger;

class Action {
    Entity target;
    int staminaRequired;
    Action alternate; // An alternate action that can be attempted if this one cannot execute

    this(Entity target) {
        this.target = target;
    }

    // Execute this action in the given world
    void execute(World world) {
        // Clear the target's actions (this will be called by subclasses after they do their thing)
        target.desiredAction = null;
    }
    
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
        auto oldPosition = target.position;
        auto newPosition = oldPosition + Point(x, y);
        target.position = newPosition;
        Event e = Movement(target, oldPosition, newPosition);
        target.world.game.events.throwEvent(e);
        super.execute(world);
    }

    override bool canExecute(World world) {
        Point targetPoint = target.position + Point(x, y);
        bool targetClear = true;

        // Check if the target tile is not a wall
        if (!target.canTraverse(world.map.getTile(targetPoint))) {
            targetClear = false;
            // Jump ahead and skip checking entities -- We've already decided we can't move 
            goto target_found;
        }
        // check if any entities are standing on the target position
        foreach (entity; world.entities) {
            if (entity != target) {
                if (entity.position == targetPoint) {
                    targetClear = false;
                    // Jump ahead to skip any further entity checks
                    goto target_found;
                }
            }
        }

target_found:

        // Check if we have at least staminaRequired stamina
        bool enoughStamina = target.stamina >= staminaRequired;
        // If we the target spot is taken, set our alternate action
        if (!targetClear)
            this.alternate = new AttackAction(target, x, y);

        return targetClear && enoughStamina && target.alive;
    }
}

class AttackAction : Action {
    int x, y;
    int damage;

    this(Entity target, int x, int y) {
        super(target);
        this.x = x;
        this.y = y;
        staminaRequired = 10;
        damage = 1;
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
            foreach (equip; target.inventory.equipment) {
                equip.onAttack(target, this);
            }
            entAtLocation.takeHit(target, damage); // Do 1 damage to the target
        }
    }

    override bool canExecute(World world) {
        // All we need is enough stamina and our target being alive
        return target.stamina >= staminaRequired && target.alive;
    }
}
