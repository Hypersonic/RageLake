import std.string;
import entity;
import player;
import game : Game;
import config : Config;

class World {
    Entity[] entities; // In the future, this should probably be a linked list
    Player player;
    Game game;

    // Step all entities forwards
    void step() {
        foreach (e; entities) {
            auto keysPressed = game.getKeysPressed();
            KeyType[] keytypes;

            // Convert our KeyStates to KeyTypes
            foreach (key; keysPressed) {
                keytypes ~= Config.getKeyType(key);
            }
            
            game.display.drawDebugMessage(format("KeyTypes: %s", keytypes));

            foreach (key; keytypes) {
                e.recieveKey(key);
            }

            e.update(this);
        }
    }

    this(Game g) {
        this.game = g;
        player = new Player(this);
        entities ~= player;
    }
}
