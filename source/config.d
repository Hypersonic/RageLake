import std.stdio;
import util : KeyState, KeyType;
import deimos.ncurses.ncurses;

class Config {
    KeyType[int] keymap;
    this() {
        // Bind default keys
        foreach (k; ['h', 'H', KEY_LEFT])
            keymap[k] = KeyType.MOVE_LEFT;
        foreach (k; ['l', 'L', KEY_RIGHT])
            keymap[k] = KeyType.MOVE_RIGHT;
        foreach (k; ['k', 'K', KEY_UP])
            keymap[k] = KeyType.MOVE_UP;
        foreach (k; ['j', 'J', KEY_DOWN])
            keymap[k] = KeyType.MOVE_DOWN;
        foreach (k; ['q', 'Q'])
            keymap[k] = KeyType.QUIT;
    }

    KeyType getKeyType(KeyState state) pure {

        return keymap.get(state.keyCode, KeyType.NONE);
    }
}
