import std.signals;
import std.variant;
import std.string;
import game : Game;
import entity : Entity;
import util : Point;
import logger;

struct KeyPress {
    char key;
}

struct Movement {
    Entity entity;
    Point from;
    Point to;
}

alias Event = Algebraic!(KeyPress, Movement);

class EventManager {
    Game game;
    private Event[] events;

    this(Game game) {
        this.game = game;
    }

    void throwEvent(Event event) {
        events ~= event;
        try {
            emit(event);
            log("Emitted Event", event);
        } catch (Exception e) {
            log("Error emitting Event", event, ":", e.msg);
        }
    }

    mixin Signal!(Event);
}
