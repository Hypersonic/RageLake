import std.stdio;
import std.string;
import std.variant;
import std.signals;
import std.datetime;
import std.algorithm;
import std.math;
import deimos.ncurses.ncurses;
import display;
import world;
import console;
import enemy;
import config;
import logger;
import util;
import event : EventManager, Event;
import screenstack;
import core.thread;

class Game : Screen {
    EventManager events;
    Display display;
    World world;
    Config config;
    Console console;
    long turncount;

    this() {
        auto viewport = Bounds(Point(0,0), Point(10, 10));
        events = new EventManager(this);
        display = new Display(viewport);
        console = new Console(this);
        world = new World(this);
        config = new Config(this);
        console.registerFunction("quit", delegate(string[] s) {
                import app;
                while (!screens.empty) {
                    screens.pop();
                }
                }, "Exit the game");
        console.registerFunction("redraw", delegate(string[] s) { this.display.clear(); this.display.forceRefresh(); }, "Redraw the screen");
        turncount = 0;
    }

    void tick() {
        StopWatch sw;

        logUpdate("Turn: %d", turncount);

        sw.start();
        world.step();
        sw.stop();

        logUpdate("World step time (msecs): %d", sw.peek().msecs); 

        // Update the viewport to be centered on the player
        auto playerpos = world.player.position;
        auto centerpos = Point(display.viewport.min.x + display.viewport.width / 2, 
                               display.viewport.min.y + display.viewport.height / 2);
        auto dist = Point(abs(playerpos.x - centerpos.x),
                          abs(playerpos.y - centerpos.y));
        auto max = Point(display.viewport.width / 4, display.viewport.height / 3);
        logDebug("Distance (center): %s; max: %s", dist, max);
        bool changedViewport = false;
        if (dist.x >= max.x) {
            display.viewport.min.x = playerpos.x - display.width / 2;
            display.viewport.max.x = playerpos.x + display.width / 2;
            changedViewport = true;
        }
        if (dist.y >= max.y) {
            display.viewport.min.y = playerpos.y - display.height / 2;
            display.viewport.max.y = playerpos.y + display.height / 2;
            changedViewport = true;
        }

        // This is a bugfix to prevent weird artifacting that sometimes happens when the viewport moves
        if (changedViewport) {
            display.clear();
            display.forceRefresh();
        }
    }

    override void render(Display display) {
        StopWatch sw;
        sw.start();
        world.render(display);
        sw.stop();

        logUpdate("Display update time (msecs): %d", sw.peek().msecs);

        Thread.sleep(dur!("msecs")(20));
    }

    override void takeInput(KeyPress kp) {
        auto cmd = config.getCommand(kp);
        console.submit(cmd);
    }

}
