import std.signals;
import std.variant;
import std.string;
import game;
import entity : Entity;
import util : Point;
import logger;

struct KeyPress {
    string key;
    bool esc_seq; // is this an escape sequence
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
        // TODO: Find a way to remove try/catch when throwing events
        try {
            emit(event);
            logDiagnostic("Emitted Event %s", event);
        } catch (Exception e) {
            logError("Error emitting Event %s : %s", event, e.msg);
        }
    }

    mixin Signal!(Event);
}
