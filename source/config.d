import util : KeyState, KeyType;
import deimos.ncurses.ncurses;

class Config {
    @safe static KeyType getKeyType(KeyState state) pure {
        switch (state.keyCode) {
        case KEY_LEFT:
            return KeyType.MOVE_LEFT;
        case KEY_RIGHT:
            return KeyType.MOVE_RIGHT;
        case KEY_UP:
            return KeyType.MOVE_UP;
        case KEY_DOWN:
            return KeyType.MOVE_DOWN;
        case 'q':
        case 'Q':
            return KeyType.QUIT;
        default:
            return KeyType.NONE;
        }
    }
}
