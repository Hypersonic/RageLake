import std.signals;
import std.variant;
import std.string;
import game : Game;

struct KeyPress {
    char key;
}

alias Event = Algebraic!(KeyPress);

class EventManager {
    Game game;
    Event[] events;

    this(Game game) {
        this.game = game;
    }

    void throwEvent(Event event) {
        events ~= event;
        try {
            emit(event);
        } catch (Exception e) {
            game.console.logmsg(format("Error emitting Event %s: %s", event, e.msg));
        }
    }

    mixin Signal!(Event);
}
