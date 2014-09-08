import std.string;
import std.functional;
import std.traits;
import game;
import util : Event, EventType, DataType;
import display;
import deimos.ncurses.ncurses;

class Console {
    Game game;
    string input = "";
    string[] log;
    void delegate(string[])[string] functions;
    string[string] helpStrings;
    int height = 10;

    this(Game game) {
        this.game = game;
        input = "";
        game.display.connect(&this.render);
        this.registerFunction("echo", delegate(string[] args) { this.logmsg(args.join(" ")); }, "Print all passed in arguments" );
        this.registerFunction("openConsole", delegate(string[] args) { this.game.consoleMode = true; }, "Open the developer console");
    }

    void watch(Event event) {
        if (event.type == EventType.KEY_PRESS) {
            // When they press backspace
            if (event.data.key == 127) {
                if (input.length > 0)
                    input = input[0 .. $-1];
            } else if (event.data.key == 13) { // Return
                logmsg(input);
                submit(input);
                input = "";
            } else if (event.data.key == '`') {
                this.game.consoleMode = false;
            } else {
                input ~= event.data.key;
            }
        }
    }

    void logmsg(string msg) {
        log ~= msg;
    }

    void submit(string cmd) {
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

    // Bind a function to a name, along with an optional help string
    @safe void registerFunction(F)(string name, auto ref F fp, string help = "") pure nothrow if (isCallable!F) {
        functions[name] = toDelegate(fp);
        helpStrings[name] = help;
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
