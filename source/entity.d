import world : World;
import display : Cell;

class Entity {
    int x, y;
    Cell cell;

    this() {
        this(0, 0);
    }

    this(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // Do any setup required to step before any entities step
    void preStep(World world) {
    }
    // Step forward in time in the given world
    void step(World world) {
    }
    // Cleanup after stepping
    void postStep(World world) {
    }

}
