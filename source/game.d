import std.stdio;
import std.string;
import std.signals;
import deimos.ncurses.ncurses;
import display;
import world;
import util : KeyState, Point, Bounds, KeyType, EventType;
import core.thread;

class Game {
    Display display;
    World world;
    bool running = true;

    this() {
        int width, height;
        width = 80;
        height = 40;
        auto viewport = Bounds(Point(0,0), Point(width, height));
        display = new Display(width, height, viewport);
        world = new World(this);
        this.connect(&this.watch);
    }

    void run() {
        while(running) {
            auto keysPressed = getKeysPressed();

            display.drawDebugMessage(format("KeyTypes: %s", keysPressed));

            world.step();

            // Update the viewport to be centered on the player
            auto playerpos = world.player.position;
            display.viewport.min.x = playerpos.x - display.width / 2;
            display.viewport.max.x = playerpos.x + display.width / 2;
            display.viewport.min.y = playerpos.y - display.height / 2;
            display.viewport.max.y = playerpos.y + display.height / 2;

            display.update(world);
            Thread.sleep(dur!("msecs")(20));
        }
    }

    void watch(EventType event, KeyType key) {
        if (event == EventType.KEY_PRESS) {
        if (key == KeyType.QUIT) {
            running = false;
        }
        }
    }

    KeyType[] getKeysPressed() {
        KeyState[] states;
        int code;
        do {
            code = getch();
            // Scan through the list for a dupe of this code
            bool found = false;
            foreach (key; states) {
                if (key.keyCode == code)
                    found = true;
            }
            // Only insert if there isn't already a copy of this code in the list
            if (!found) {
                auto state = KeyState(code, true);
                states ~= state;
            }
        } while (code != ERR);
        KeyType[] types;
        foreach (state; states[0 .. $-1]) {
            auto type = Config.getKeyType(state);
            types ~= type;
            emit(EventType.KEY_PRESS, type);
        }
        return types;
    }
    mixin Signal!(EventType, KeyType);
}
