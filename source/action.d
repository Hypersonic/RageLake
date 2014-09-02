import world;
import entity;

// The vanilla action is abstract, all actual actions should be subclasses
abstract class Action {
    int staminaRequired;

    // Execute this action in the given world
    void execute(World w) {}
}

class MovementAction : Action {
    Entity mover;
    int x, y;

    this(Entity mover, int x, int y) {
        this.mover = mover;
        this.x = x;
        this.y = y;
        staminaRequired = 10;
    }

    void execute(World w) {
        if (mover.stamina >= staminaRequired) {
            mover.stamina -= staminaRequired;
            mover.position.x += x;
            mover.position.y += y;
        }
    }
}
