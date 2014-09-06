import deimos.ncurses.ncurses;

class Config {
    string[char] keybinds;

    this() {
        // Bind default keys
        foreach (k; ['h', 'H', KEY_LEFT])
            bindKey(cast(char) k, "left");
        foreach (k; ['l', 'L', KEY_RIGHT])
            bindKey(cast(char) k, "right");
        foreach (k; ['k', 'K', KEY_UP])
            bindKey(cast(char) k, "up");
        foreach (k; ['j', 'J', KEY_DOWN])
            bindKey(cast(char) k, "down");
        foreach (k; ['q', 'Q'])
            bindKey(cast(char) k, "quit");
        foreach (k; [':'])
            bindKey(cast(char) k, "openConsole");
    }

    void bindKey(char keyCode, string command) {
        keybinds[keyCode] = command;
    }

    string getCommand(char keyCode) {
        return keybinds.get(keyCode, "");
    }
}
