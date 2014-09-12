import std.signals;
import game : Game;

enum EventType {
    RAW_KEY_PRESS,
    KEY_PRESS
}

union DataType {
    char key;
}


struct Event {
    EventType type;
    DataType data;
}

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
