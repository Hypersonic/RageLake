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
            foreach (key; game.getKeysPressed()) {
                e.recieveKey(Config.getKeyType(key));
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
