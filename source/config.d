import std.stdio;
import util : KeyState, KeyType;
import deimos.ncurses.ncurses;

class Config {
    static KeyType getKeyType(KeyState state) pure {
        KeyType[int] keymap;
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

        return keymap.get(state.keyCode, KeyType.NONE);
    }
}
