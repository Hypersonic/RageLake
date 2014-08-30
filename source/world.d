import entity;

class World {
    Entity[] entities; // In the future, this should probably be a linked list

    // Step all entities forwards
    void step() {
        foreach (e; entities) {
            e.preStep(this);
        }
        foreach (e; entities) {
            e.step(this);
        }
        foreach (e; entities) {
            e.postStep(this);
        }
    }
}
