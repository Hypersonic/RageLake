import std.conv;
import std.string;
import std.variant;
import std.functional;
import std.traits;
import std.algorithm;
import game;
import event : Event, KeyPress;
import display;
import logger;
import screenstack;

class Console : Screen {
    Game game;
    private string input = "";
    private static string prompt = ":> ";
    private string[] log;
    private void delegate(string[])[string] functions;
    private string[string] helpStrings;
    private @property int height() {
        return min(50, game.display.height);
    }
    private @property int width() {
        return reduce!((a,b) => max(a,b) )(0, (log ~ (prompt ~ input)).map!(x => x.length.to!int)());
    }



    this(Game game) {
        // Screen settings
        inputFallthrough = false;
        isTransparent = true;

        this.game = game;
        input = "";

        auto consoleLogger = new ConsoleLogger();

        this.registerFunction("echo", delegate(string[] args) { this.logmsg(args.join(" ")); }, "Print all passed in arguments" );
        this.registerFunction("openConsole", delegate(string[] args) {
                import app;
                    screens.push(this);
                }, "Open the developer console");
        this.registerFunction("help", delegate(string[] args) {
                if (args.length == 0) {
                    this.logmsg("Whadaya want help with?");
                    return;
                }
                auto help = helpStrings.get(args[0], "No such command");
                this.logmsg(args[0] ~ ": " ~ help);
                }, "Ask for info about a command");
        this.registerFunction("alias", delegate(string[] args) {
                if (args.length < 2) {
                    this.logmsg("You need to specify at least 2 arguments");
                    return;
                }
                this.registerFunction(args[0], delegate(string[] subargs) {
                    // Submit commands split by semicolons
                        foreach (subcmd; args[1..$].join(" ").split(";").map!(strip)()) {
                            this.submit(subcmd);
                        }
                    });
                }, "Alias a command name to a `;` delimited series of commands");
    }

    override void takeInput(KeyPress kp) {
        switch (kp.key) {
            case 127: // Backspace
                if (input.length > 0) input = input[0 .. $-1];
                break;
            case 13: // Return
                logmsg(input);
                submit(input);
                input = "";
                break;
            case 27: // ESC
                import app;
                screens.pop();
                break;
            default:
                input ~= kp.key;
                break;
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
        string[] args;
        if (splitcmd.length > 1)
            args = splitcmd[1..$];
        else
            args = [];
        fun(args);
    }

    // Bind a function to a name, along with an optional help string
    @safe void registerFunction(F)(string name, auto ref F fp, string help = "") pure nothrow if (isCallable!F) {
        functions[name] = toDelegate(fp);
        helpStrings[name] = help;
    }

    override void render(Display display) {
        // Assemble a backing of maximum width
        auto backing = "| ";
        auto underline = "--";
        foreach(x; 0 .. width) {
            backing ~= " ";
            underline ~= "-";
        }
        int x = display.width;
        int y = 0;
        int height = min(this.height, log.length);
        foreach (msg; log[$-height .. $]) {
            display.drawString(cast(int) (x - backing.length), y, backing);
            display.drawString(cast(int) (x - msg.length), y, msg);
            y++;
        }
        auto instr = prompt ~ input;
        display.drawString(cast(int) (x - backing.length), y, backing);
        display.drawString(cast(int) (x - instr.length), y, instr);
        y++;
        display.drawString(cast(int) (x - underline.length), y, underline);
    }

    class ConsoleLogger : Logger {
        this() {
            this.minLevel = LogLevel.error;
            registerLogger(this);
        }

        override void log(ref LogLine line) {
            logmsg(line.file ~ ":" ~ line.line.to!string ~ " " ~ line.msg ~ "\n");
        }
    }
}
