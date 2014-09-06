import std.string;
import entity;
import player;
import enemy;
import game : Game;

class World {
    Entity[] entities; // In the future, this should probably be a linked list
    Player player;
    Game game;

    // Step all entities forwards
    void step() {
        game.display.drawDebugMessage(format("Entities: %d", entities.length));
        foreach (e; entities) {
            e.update(this);
        }
        foreach (e; entities) {
            if (e.desiredAction && e.desiredAction.canExecute(this)) {
                e.desiredAction.execute(this);
                e.desiredAction = null;
            }
        }
    }

    this(Game g) {
        this.game = g;
        player = new Player(this);
        entities ~= player;
        entities ~= new Enemy(this);
        game.console.registerFunction("spawnenemy", delegate(string[] s) {
                auto e = new Enemy(this);
                e.position = player.position;
                entities ~= e;
                }, "Spawn an enemy at the player's position");
    }
}
