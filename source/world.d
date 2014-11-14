import std.string;
import map;
import entity;
import player;
import enemy;
import action;
import logger;
import display;
import game : Game;
import util : Point;
import tile;
import randommap;

class World {
    Entity[] entities; // In the future, this should probably be a linked list
    Player player;
    Game game;
    Map map;

    // Step all entities forwards
    void step() {
        Action[] actions;
        logUpdate("Entities: %d", entities.length);
        auto requiredActions = entities.length;
        foreach (e; entities) {
            e.update(this);
        }
        foreach (e; entities) {
            // Only able to move if we're at maximum stamina;
            // If any entity is at maximum stamina, it must take an action
            // This effectively has "cooldown" for actions,
            // as well as enforcing a "maximum" on the intensity of the action an entity can take
            if (e.stamina < e.maxStamina) {
                requiredActions--;
            } else
            if (e.desiredAction) {
                actions ~= e.desiredAction;
            }
        }
        // only execute actions if we have one for every entity that can act
        if (actions.length == requiredActions && requiredActions > 0) {
            game.turncount++;
            foreach (action; actions) {
                while (!action.canExecute(this)) {
                    if (action.alternate) {
                        action = action.alternate;
                    } else {
                        break;
                    }
                }
                if (action.canExecute(this)) {
                    action.execute(this);
                    action.target.desiredAction = null;
                }
            }
        }
    }

    this(Game g) {
        this.game = g;
        this.map = new Map(new RandomMapGenerator());

        game.display.connect(&this.render);

        player = new Player(this);
        entities ~= player;
        entities ~= new Enemy(this);


        game.console.registerFunction("spawnenemy", delegate(string[] s) {
                auto e = new Enemy(this);
                e.position = player.position;
                entities ~= e;
                }, "Spawn an enemy at the player's position");
    }

    void render(RenderDepth rd, Display d) {
        map.render(rd, d);
    }
}
