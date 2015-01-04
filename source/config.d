import std.string;
import game;
import deimos.ncurses.ncurses;
import event;

class Config {
    Game game;
    string[KeyPress] keybinds;

    this(Game g) {
        this.game = g;
        // Bind default keys
        foreach (k; ['h', 'H', KEY_LEFT])
            bindKey(KeyPress("" ~ cast(char)k), "left");
        foreach (k; ['l', 'L', KEY_RIGHT])
            bindKey(KeyPress("" ~ cast(char)k), "right");
        foreach (k; ['k', 'K', KEY_UP])
            bindKey(KeyPress("" ~ cast(char)k), "up");
        foreach (k; ['j', 'J', KEY_DOWN])
            bindKey(KeyPress("" ~ cast(char)k), "down");
        foreach (k; ['q', 'Q'])
            bindKey(KeyPress("" ~ cast(char)k), "quit");
        foreach (k; [':'])
            bindKey(KeyPress("" ~ cast(char)k), "openConsole");
        foreach (k; ['i', 'I'])
            bindKey(KeyPress("" ~ cast(char)k), "openinventory");
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
                    this.bindKey(KeyPress(s[0]), join(s[1..$], " "));
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
                    this.unbindKey(KeyPress(s[0]));
                });
        g.console.registerFunction("listbinds",
                delegate(string[] s) {
                foreach (key, command; this.keybinds) {
                    game.console.logmsg("%s : %s".format(key, command));
                }
                }, "List all binds");
    }

    @safe void bindKey(KeyPress key, string command) pure nothrow {
        keybinds[key] = command;
    }

    @safe void unbindKey(KeyPress key) pure nothrow {
        keybinds.remove(key);
    }

    @trusted string getCommand(KeyPress key) pure {
        return keybinds.get(key, "");
    }
}
