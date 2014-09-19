import entity : Entity;
import world : World;
import logger;
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
                }, "LIVE, Liiiiiiiive!");
    }

    override Action update(World world) {
        logUpdate("Stamina: %d", stamina);
        logUpdate("HP: %d", health);
        super.update(world);
        return this.desiredAction;
    }
}
