import enemy;
import action;

class Behavior {
    Enemy entity;

    this(Enemy ent) {
        this.entity = ent;
    }

    Action getNextAction(World world) {
        auto act = new Action(entity);
        act.staminaRequired *= 5;
        return act;
    }
}
