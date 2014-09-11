import std.string;
import game;
import deimos.ncurses.ncurses;

class Config {
    Game game;
    string[char] keybinds;

    this(Game g) {
        this.game = g;
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
        g.console.registerFunction("bind",
                delegate(string[] s) {
                    if (s.length < 2) {
                        g.console.logmsg(format("Error, `bind` requires 2 arguments, got %d", s.length));
                        return;
                    }
                    if (s[0].length != 1) {
                        g.console.logmsg("Error, `bind` requires first argument to be a character, got \"" ~ s[0] ~ "\"");
                        return;
                    }
                    this.bindKey(s[0][0], join(s[1..$], " "));
                });
        g.console.registerFunction("unbind",
                delegate(string[] s) {
                    if (s.length < 1) {
                        g.console.logmsg(format("Error, `unbind` requires 1 argument, got %d", s.length));
                        return;
                    }
                    if (s[0].length != 1) {
                        g.console.logmsg("Error, `unbind` requires first argument to be a character, got \"" ~ s[0] ~ "\"");
                        return;
                    }
                    this.unbindKey(s[0][0]);
                });
    }

    @safe void bindKey(char keyCode, string command) pure nothrow {
        keybinds[keyCode] = command;
    }

    @safe void unbindKey(char keyCode) pure nothrow {
        keybinds.remove(keyCode);
    }

    @trusted string getCommand(char keyCode) pure {
        return keybinds.get(keyCode, "");
    }
}
