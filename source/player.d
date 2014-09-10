import std.string;
import entity : Entity;
import world : World;
import action : Action, MovementAction;
import util : Color;

class Player : Entity {

    this(World world) {
        super(world);
        cell.glyph = '@';
        normalColor = Color.PLAYER;
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
        this.world.game.console.registerFunction("phoenix", delegate(string[] s) {
                this.alive = true;
                this.normalColor = Color.PLAYER;
                this.health = this.maxHealth;
                });
    }

    override Action update(World world) {
        this.world.game.display.drawDebugMessage(format("Stamina: %d", stamina));
        this.world.game.display.drawDebugMessage(format("HP: %d", health));
        super.update(world);
        return this.desiredAction;
    }
}
