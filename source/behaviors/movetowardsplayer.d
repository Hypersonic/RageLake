module behaviors.movetowardsplayer;

import std.math;

import behavior;
import enemy;
import action;

class MoveTowardsPlayerBehavior : Behavior {
    this(Enemy target) {
        super(target);
    }

    // TODO: Use A* to determine the path
    override Action getNextAction(World world) {

        float dx = world.player.position.x - entity.position.x;
        float dy = world.player.position.y - entity.position.y;
        float len = sqrt(dx * dx + dy * dy);
        // normalize
        dx = round(cast(float) dx / len);
        dy = round(cast(float) dy / len);

        if (len < 3) {
            import behaviors.randomwalkbehavior;
            entity.behavior = new RandomWalkBehavior(entity);
        }

        auto act = new MovementAction(entity, cast(int) dx, cast(int) dy);
        act.staminaRequired *= 5;
        return act;
    }
}
