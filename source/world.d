import entity;
import player;
import game : Game;
import config : Config;

class World {
    Entity[] entities; // In the future, this should probably be a linked list
    Player player;

    // Step all entities forwards
    void step() {
        foreach (e; entities) {
            foreach (key; Game.getKeysPressed()) {
                e.update(Config.getKeyType(key), this);
            }
        }
    }

    this() {
        player = new Player(this);
        entities ~= player;
    }
}
