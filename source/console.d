import std.string;
import std.functional;
import std.traits;
import std.array;
import game;
import util : Event, EventType, DataType, KeyType, KeyState;
import display;
import deimos.ncurses.ncurses;

class Console {
    Game game;
    string input = "";
    string[] log;
    void delegate(string[])[string] functions;
    int height = 10;

    this(Game game) {
        this.game = game;
        input = "";
        game.display.connect(&this.render);
        this.registerFunction("echo", delegate(string[] args) { this.logmsg(args.join(" ")); } );
    }

    void watch(Event event) {
        // Disable console when user hits cancel key
        if (event.type == EventType.KEY_PRESS && event.data.key == KeyType.CANCEL) {
            game.consoleMode = false;
        }
        if (event.type == EventType.RAW_KEY_PRESS) {
            // When they press backspace
            if (event.data.rawKey.keyCode == 127) {
                if (input.length > 0)
                    input = input[0 .. $-1];
            } else if (event.data.rawKey.keyCode == 13) { // Return
                submit(input);
                input = "";
            } else if (game.config.getKeyType(event.data.rawKey) != KeyType.CANCEL) {
                input ~= cast(char) event.data.rawKey.keyCode;
            }
        }
    }

    void logmsg(string msg) {
        log ~= msg;
    }

    void submit(string cmd) {
        logmsg(cmd);
        if (cmd == "") return;
        auto splitcmd = cmd.split(" ");
        string cmdToCall = "";
        if (splitcmd.length > 0)
            cmdToCall = splitcmd[0];
        auto err = delegate(string[] s) { this.logmsg("Error, no fn found with name \"" ~ cmdToCall ~ "\""); };
        auto fun = functions.get(cmdToCall, err);
        string[] callcmd;
        if (splitcmd.length > 1)
            callcmd = splitcmd[1..$];
        else
            callcmd = [];
        fun(callcmd);
    }

    void registerFunction(F)(string name, auto ref F fp) if (isCallable!F) {
        functions[name] = toDelegate(fp);
    }

    void render(Display display) {
        int x = display.width;
        int y = 0;
        auto usedlog = log;
        if (usedlog.length > this.height) {
            usedlog = usedlog[$-this.height..$];
        }
        foreach (msg; usedlog) {
            display.drawString(cast(int) (x - msg.length), y, msg);
            y++;
        }
        auto instr = ":> " ~ input;
        display.drawString(cast(int) (x - instr.length), y, instr);
    }
}
