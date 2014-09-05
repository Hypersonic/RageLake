import std.stdio;
import std.string;
import std.signals;
import std.datetime;
import deimos.ncurses.ncurses;
import display;
import world;
import enemy;
import util : KeyState, Point, Bounds, KeyType, EventType, Event, DataType;
import core.thread;

class Game {
    Display display;
    World world;
    Config config;
    long turncount;
    bool running = true;

    this() {
        int width, height;
        width = 80;
        height = 40;
        auto viewport = Bounds(Point(0,0), Point(width, height));
        display = new Display(width, height, viewport);
        world = new World(this);
        config = new Config();
        turncount = 0;
        this.connect(&this.watchKeys);
    }

    void run() {
        while(running) {
            StopWatch sw;
            turncount++;
            auto keysPressed = getKeysPressed();

            display.drawDebugMessage(format("KeyTypes: %s", keysPressed));
            display.drawDebugMessage(format("Turn: %d", turncount));


            sw.start();
            world.step();
            sw.stop();

            display.drawDebugMessage(format("World step time (msecs): %d", sw.peek().msecs)); 

            // Update the viewport to be centered on the player
            auto playerpos = world.player.position;
            display.viewport.min.x = playerpos.x - display.width / 2;
            display.viewport.max.x = playerpos.x + display.width / 2;
            display.viewport.min.y = playerpos.y - display.height / 2;
            display.viewport.max.y = playerpos.y + display.height / 2;

            sw.reset();
            sw.start();
            display.update(world);
            sw.stop();

            display.drawDebugMessage(format("Display update time (msecs): %d", sw.peek().msecs));

            Thread.sleep(dur!("msecs")(20));
        }
    }

    void watchKeys(Event event) {
        if (event.type == EventType.KEY_PRESS) {
        if (event.data.key == KeyType.QUIT) {
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

        // Convert to KeyTypes and emit events
        KeyType[] types;
        foreach (state; states[0 .. $-1]) {
            auto type = config.getKeyType(state);
            types ~= type;
            emit(Event(EventType.KEY_PRESS, DataType(type)));
        }
        return types;
    }
    mixin Signal!(Event);
}
