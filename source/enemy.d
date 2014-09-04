import std.random;
import entity : Entity;
import world : World;
import action : MovementAction;

class Enemy : Entity {
    this(World w) {
        super(w);
        cell.glyph = 'e';
    }

    override void update(World world) {
        this.desiredAction = new MovementAction(this, uniform(-1, 2), uniform(-1, 2));
        this.desiredAction.staminaRequired *= 5;
        super.update(world);
    }
}
