module behaviors.randomwalkbehavior;

import std.random;

import behavior;
import entity;
import action;


class RandomWalkBehavior : Behavior {
    
    this(Entity ent) {
        super(ent);
    }

    override Action getNextAction(World world) {
        auto act = new MovementAction(entity, uniform(-1, 2), uniform(-1, 2));
        act.staminaRequired *= 5;
        return act;
    }
}
