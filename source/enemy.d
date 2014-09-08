import std.random;
import entity : Entity;
import world : World;
import action : Action, MovementAction;
import util : Color;

class Enemy : Entity {
    this(World w) {
        super(w);
        cell.glyph = 'e';
        cell.color = Color.ENEMY;
    }

    override Action update(World world) {
        this.desiredAction = new MovementAction(this, uniform(-1, 2), uniform(-1, 2));
        this.desiredAction.staminaRequired *= 5;
        super.update(world);
        return this.desiredAction;
    }
}
