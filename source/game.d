import std.stdio;
import std.string;
import std.signals;
import std.datetime;
import std.algorithm;
import deimos.ncurses.ncurses;
import display;
import world;
import console;
import enemy;
import config;
import util : Point, Bounds, EventType, Event, DataType;
import core.thread;

class Game {
    Display display;
    World world;
    Config config;
    Console console;
    long turncount;
    bool running = true;
    bool consoleMode = false;

    this() {
        int width, height;
        width = 80;
        height = 40;
        auto viewport = Bounds(Point(0,0), Point(width, height));
        display = new Display(width, height, viewport);
        console = new Console(this);
        world = new World(this);
        config = new Config();
        console.registerFunction("quit", delegate(string[] s) { this.running = false; });
        turncount = 0;
        this.connect(&this.watchKeys);
    }

    void run() {
        while(running) {
            StopWatch sw;
            auto keysPressed = getKeysPressed();

            display.drawDebugMessage(format("KeyTypes: %s", keysPressed));
            display.drawDebugMessage(format("Turn: %d", turncount));

            if (!consoleMode) {
                turncount++;

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

            }
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
            auto cmd = config.getCommand(event.data.key);
            console.submit(cmd);
        }
    }

    void emitEvent(Event event) {
        if (!this.consoleMode) {
            emit(event);
        } else {
            console.watch(event);
        }
    }

    char[] getKeysPressed() {
        char[] states;
        char[] emitted;
        int code;
        while ((code = getch()) != ERR){
            states ~= code;
        }
        foreach (state; uniq(states)) {
            auto key = DataType();
            key.key = cast(char) state;
            emitEvent(Event(EventType.KEY_PRESS, key));
            emitted ~= cast(char) state;
        }
        return emitted;
    }
    mixin Signal!(Event);
}
