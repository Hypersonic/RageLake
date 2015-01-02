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
    private int minwidth = 50;
    private string[] log;
    private void delegate(string[])[string] functions;
    private string[string] helpStrings;
    private @property int height() {
        return min(50, game.display.height);
    }
    private @property int width() {
        return reduce!((a,b) => max(a,b) )(minwidth, (log ~ (prompt ~ input))
                .map!(x => x.length.to!int));
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
        this.registerFunction("listcommands", delegate(string[] args) {
                foreach (cmd; functions.keys) {
                    logmsg(cmd);
                }
                }, "List all commands");
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
            case '\t': // Tab, attempt autocomplete
                auto comps = getAutoCompleteChoices(input);
                if (input.length > 0 && comps.length > 0) {
                    input = comps[0];
                }
                break;
            default:
                input ~= kp.key;
                break;
        }
    }

    @safe void logmsg(string msg) pure {
        log ~= msg;
    }

    void submit(string cmd) {
        //TODO: Implement a proper parser for commands, not just string.split
        if (cmd == "") return;
        auto splitcmd = cmd.split(" ");
        string cmdToCall = "";
        if (splitcmd.length > 0)
            cmdToCall = splitcmd[0];
        auto err = delegate(string[] s) {
            import std.array;
            auto alternatives = functions.keys.filter!(a => a.levenshteinDistance(input) < 8).array.sort!((a, b) => a.levenshteinDistance(input) < b.levenshteinDistance(input));
            this.logmsg("Error, no fn found with name \"" ~ cmdToCall ~ "\"");
            if (alternatives.length > 0) {
                this.logmsg("Did you mean \"" ~ alternatives[0] ~ "\"?");
            }
        };
        auto fun = functions.get(cmdToCall, err);
        string[] args;
        if (splitcmd.length > 1)
            args = splitcmd[1..$];
        fun(args);
    }

    // Bind a function to a name, along with an optional help string
    @safe void registerFunction(F)(string name, auto ref F fp, string help = "") pure nothrow if (isCallable!F) {
        functions[name] = toDelegate(fp);
        helpStrings[name] = help;
    }

    // Automatically create a function to set a specific variable
    // NOTE: The type of the variable must support conversion from a string, as specified in the docs for std.conv
    @safe void registerVariable(T)(string name, ref T var) pure nothrow {
        this.registerFunction(name, delegate(string[] args) {
                if(args.length == 0) {
                    logmsg("Cannot set " ~ name ~ ", you must supply an argument.");
                    return;
                }
                try {
                    var = args[0].to!T;
                } catch (ConvException e) {
                    logmsg(e.msg);
                }
                });
    }

    auto getAutoCompleteChoices(string input) {
        import std.array;
        auto comps = functions.keys.filter!(s => s.startsWith(input)).array;
        return comps;
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

        // Try to complete if possible
        auto instr = prompt ~ input;
        display.drawString(cast(int) (x - backing.length), y, backing);

        auto comps = getAutoCompleteChoices(input);

        if (input.length > 0 && comps.length > 0) {
            // Found an autocompletion, draw that
            auto comp = prompt ~ comps[0];
            if (comp.length > prompt.length)
                display.drawString(cast(int) (x - comp.length), y, comp, Color.IMPORTANT);
            display.drawString(cast(int) (x - comp.length), y, instr);
        } else {
            // No autocommpletion found
            display.drawString(cast(int) (x - instr.length), y, instr);
        }

        y++;
        display.drawString(cast(int) (x - underline.length), y, underline);
    }

    class ConsoleLogger : Logger {
        this() {
            this.minLevel = LogLevel.info;
            registerLogger(this);
            registerVariable("console_log_level", minLevel);
        }

        override void log(ref LogLine line) {
            logmsg(line.file ~ ":" ~ line.line.to!string ~ " " ~ line.msg ~ "\n");
        }
    }
}
