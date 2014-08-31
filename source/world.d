import entity;
import player;
import game : Game;

class World {
    Entity[] entities; // In the future, this should probably be a linked list
    Player player;

    // Step all entities forwards
    void step() {
        foreach (e; entities) {
            foreach (key; Game.getKeysPressed()) {
                e.update(key, this);
            }
        }
    }

    this() {
        player = new Player(this);
        entities ~= player;
    }
}
