import entity;
import action;

class Behavior {
    Entity entity;

    this(Entity ent) {
        this.entity = ent;
    }

    Action getNextAction(World world) {
        auto act = new Action(entity);
        act.staminaRequired *= 5;
        return act;
    }
}
