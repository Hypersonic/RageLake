import std.signals;
import std.variant;
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
        emit(event);
    }

    mixin Signal!(Event);
}
