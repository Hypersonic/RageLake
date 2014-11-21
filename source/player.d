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
        this.world.game.console.registerFunction("tp", delegate(string[] s) {
                import std.conv;
                if (s.length < 2) {
                    this.world.game.console.logmsg("You must enter 2 numbers for tp");
                    return;
                }
                // Go through double to handle any decimals
                this.position.x = s[0].to!double.to!int;
                this.position.y = s[1].to!double.to!int;
                }, "Teleport the player to specified coords");
        this.world.game.console.registerFunction("phoenix", delegate(string[] s) {
                this.alive = true;
                this.normalColor = Color.PLAYER;
                this.health = this.maxHealth;
                }, "LIVE, Liiiiiiiive!");
        this.world.game.console.registerFunction("openinventory", delegate(string[] s) {
                import inventoryscreen;
                import app;
                import console;
                if (typeid(screens.peek()) == typeid(Console))
                    screens.pop(); // Remove the console
                screens.push(new InventoryScreen(this.inventory));
                }, "Open the player's inventory");
        this.world.game.console.registerFunction("additem", delegate(string[] s) {
                import item;
                this.inventory.items ~= new Item();
                }, "Add an item to the inventory");
    }

    override Action update(World world) {
        logUpdate("Stamina: %d", stamina);
        logUpdate("HP: %d", health);
        super.update(world);
        return this.desiredAction;
    }
}
