import std.stdio;
import std.string;
import std.variant;
import std.signals;
import std.datetime;
import std.algorithm;
import deimos.ncurses.ncurses;
import display;
import world;
import console;
import enemy;
import config;
import logger;
import util : Point, Bounds;
import event : EventManager, Event;
import core.thread;

class Game {
    EventManager events;
    Display display;
    World world;
    Config config;
    Console console;
    long turncount;
    bool running = true;
    bool consoleMode = false;

    this() {
        auto viewport = Bounds(Point(0,0), Point(10, 10));
        events = new EventManager(this);
        display = new Display(viewport);
        console = new Console(this);
        world = new World(this);
        config = new Config(this);
        console.registerFunction("quit", delegate(string[] s) { this.running = false; }, "Exit the game");
        turncount = 0;
        events.connect(&this.watchKeys);
    }

    void run() {
        while(running) {
            StopWatch sw;
            auto keysPressed = getKeysPressed();

            logUpdate("KeyTypes: %s", keysPressed);
            logUpdate("Turn: %d", turncount);

            if (!consoleMode) {
                sw.start();
                world.step();
                sw.stop();

                logUpdate("World step time (msecs): %d", sw.peek().msecs); 

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

            logUpdate("Display update time (msecs): %d", sw.peek().msecs);

            Thread.sleep(dur!("msecs")(20));
        }
    }

    void watchKeys(Event event) {
        if (!consoleMode) {
            event.tryVisit!((KeyPress kp) {
                                            auto cmd = config.getCommand(kp.key);
                                            console.submit(cmd);
                                          },
                            () {}           )();
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
            Event e = KeyPress(cast(char) state);
            events.throwEvent(e);
            emitted ~= cast(char) state;
        }
        return emitted;
    }
    mixin Signal!(Event);
}
