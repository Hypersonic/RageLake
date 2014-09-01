import util : KeyState;
import deimos.ncurses.ncurses;

enum KeyType {
    MOVE_LEFT,
    MOVE_RIGHT,
    MOVE_UP,
    MOVE_DOWN,
    NONE
}
class Config {
    static KeyType getKeyType(KeyState state) {
        switch (state.keyCode) {
        case KEY_LEFT:
            return KeyType.MOVE_LEFT;
        case KEY_RIGHT:
            return KeyType.MOVE_RIGHT;
        case KEY_UP:
            return KeyType.MOVE_UP;
        case KEY_DOWN:
            return KeyType.MOVE_DOWN;
        default:
            return KeyType.NONE;
        }
    }
}
