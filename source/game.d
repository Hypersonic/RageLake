import std.stdio;
import deimos.ncurses.ncurses;
import display;
import world;
import util : KeyState;

class Game {
    Display display;
    World world;
    bool running = true;

    this() {
        display = new Display(80, 40);
        world = new World();
    }

    void run() {
        while(running) {
            world.step();
            display.update(world);
        }
    }

    static KeyState[] getKeysPressed() {
        KeyState[] states;
        int code;
        do {
            code = getch();
            states ~= KeyState(code, true);
        } while (code != ERR);
        return states;
    }


}
