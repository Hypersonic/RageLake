import std.stdio;
import display;
import world;

void main() {
    Display display;
    World world;
    display = new Display(80, 40);
    world = new World();
    bool running = true;
    while (running) {
        world.step();
        display.update();
    }
}
