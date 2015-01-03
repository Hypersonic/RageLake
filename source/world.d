import std.string;
import std.algorithm;
import std.array;

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
import generators.randomwalkmap;

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
                while (!action.canExecute(this) && action.alternate) {
                    action = action.alternate;
                }
                if (action.canExecute(this)) {
                    action.execute(this);
                }
            }
            entities = entities.filter!(e => e.alive || e.inventory.items.length > 0).array; // Remove dead entities that have no loot from the entity list
        }
    }

    this(Game g) {
        this.game = g;

        player = new Player(this);
        entities ~= player;
        foreach (i; 0 .. 20) {
            entities ~= new Enemy(this);
        }
        import item, std.random;
        foreach (i; 0 .. 20) {
            auto e = new Chest([randomItem()]);
            e.world = this;
            entities ~= e;
        }

        auto regenmap = delegate(string[] s) {
                // Render a string explaining that we're generating a map
                auto updateStr = "Generating map, please wait...";
                auto spaceing = "";
                foreach (i; 0 .. updateStr.length + 2) {
                    spaceing ~= " ";
                }
                g.display.clear();
                g.display.drawString(g.display.width / 3 - 1, 9, spaceing);
                g.display.drawString(g.display.width / 3 - 1, 10, spaceing);
                g.display.drawString(g.display.width / 3 - 1, 11, spaceing);
                g.display.drawString(g.display.width / 3, 10, updateStr);
                g.display.forceRefresh();
                this.map = new Map(this, new RandomWalkMapGenerator());
            };
        regenmap([]);
        
        game.console.registerFunction("spawnenemy", delegate(string[] s) {
                auto e = new Enemy(this);
                e.position = player.position;
                entities ~= e;
                }, "Spawn an enemy at the player's position");
        game.console.registerFunction("regeneratemap", regenmap, "Regenerate the map");
    }

    void render(Display d) {
        map.render(d);
        foreach (entity; entities) {
            entity.render(d);
        }
    }
}
