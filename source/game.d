import std.stdio;
import std.string;
import deimos.ncurses.ncurses;
import display;
import world;
import util : KeyState;
import core.thread;

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
            Thread.sleep(dur!("msecs")(20));
        }
    }

    static KeyState[] getKeysPressed() {
        KeyState[] states;
        int code;
        do {
            code = getch();
            states ~= KeyState(code, true);
        } while (code != ERR);
        return states[0..$];
    }
}
