import std.string;
import entity : Entity;
import world : World;
import action : Action, MovementAction;

class Player : Entity {

    this(World world) {
        super(world);
        cell.glyph = '@';
        this.world.game.console.registerFunction("up", delegate(string[] s) {
                this.desiredAction = new MovementAction(this, 0, -1);
                });
        this.world.game.console.registerFunction("down", delegate(string[] s) {
                this.desiredAction = new MovementAction(this, 0, 1);
                });
        this.world.game.console.registerFunction("left", delegate(string[] s) {
                this.desiredAction = new MovementAction(this, -1, 0);
                });
        this.world.game.console.registerFunction("right", delegate(string[] s) {
                this.desiredAction = new MovementAction(this, 1, 0);
                });
    }

    override Action update(World world) {
        this.world.game.display.drawDebugMessage(format("Stamina: %d", stamina));
        super.update(world);
        return this.desiredAction;
    }
}
