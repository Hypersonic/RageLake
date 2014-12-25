import entity : Entity;
import world : World;
import action : Action;
import util : Color;
import behavior;

class Enemy : Entity {
    Behavior behavior;

    this(World w) {
        super(w);
        cell.glyph = 'e';
        normalColor = Color.ENEMY;
        import behaviors.randomwalkbehavior;
        this.behavior = new RandomWalkBehavior(this);
    }

    override Action update(World world) {
        this.desiredAction = behavior.getNextAction(world);
        super.update(world);
        return this.desiredAction;
    }
}
