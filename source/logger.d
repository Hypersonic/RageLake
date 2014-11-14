import std.stdio;
import std.traits;
import std.conv;
import std.string;
import std.algorithm;

enum LogLevel {
    update, // Used for constant updates (logging framerate, etc) that may be displayed directly on screen
    trace, // Used when no stack traces are available
    debug_, // Used for debugging verbose things (_ to make D not make it a debug scope) 
    diagnostic, // Used to display extended user information (for detailed error info)
    info,
    warn,
    error,
    critical,
    fatal,
    none,
}

struct LogLine {
    string file;
    int line;
    string msg;
}

class Logger {
    LogLevel minLevel = LogLevel.info;
    bool acceptsLevel(LogLevel level) nothrow pure @safe { return level >= this.minLevel; }
    abstract void log(ref LogLine line) {}
}

class FileLogger : Logger {
    this() {
        minLevel = LogLevel.info;
        registerLogger(this);
    }
    override void log(ref LogLine line) {
        import std.file;
        append("out.log", line.file ~ ":" ~ line.line.to!string ~ " " ~ line.msg ~ "\n");
    }
}

private static Logger[] loggers;
public void registerLogger(Logger logger) {
    loggers ~= logger;
}
public void unregisterLogger(Logger logger) {
    foreach (i, l; loggers) {
        if (l is logger) {
            loggers = loggers[0 .. i] ~ loggers[i+1 .. $];
        }
    }
}
void log(LogLevel level, string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) {
    string logmsg;
    // If they only specify a string, and it has formatting characters in it, there will be an unexpected crash
    // Therefore, we check the length of the args at compile time to avoid that case
    // There is still a crash if they do not put the right number of formatting characters, but that's an expected crash
    static if (args.length == 0) {
        logmsg = fmt;
    } else {
        try {
            logmsg = format(fmt, args);
        } catch (Exception e) {
            // log the error, then throw it again so the program dies.
            logFatal("Error encountered formatting log message: %s", e.msg);
            throw e;
        }
    }
    foreach (logger; loggers) {
        if (logger.acceptsLevel(level)) {
            auto line = LogLine(file, line, logmsg);
            logger.log(line);
        }
    }
}

/*
 * Templates to generate logging functions automatically for each log level
 */
/*
 * Using the specified format, create functions for all of the elements of TL.
 * In the format, all instances of $ will be replaced by the name of the element, but it will be converted from snake_case to CamelCase.
 * % will be replaced with the name of the element, as it appears in the enum that TL is from
 */
mixin template FunctionsFor(string F, TL...) {
    static if (TL.length > 1) {
        mixin FunctionsFor!(F, TL[1..$]); 
    }
    mixin MakeFunction!(F, TL[0]);
}
mixin template MakeFunction(string F, alias T) {
    // Convert $ and % as specified above.
    mixin(translate(F, ['$' : T.to!(string).toCamelCase(), '%' : T.to!string]));
}

// Utility function to convert a string from sake_case to CamelCase
string toCamelCase(string s) pure {
    return s.split("_").map!(capitalize)().join("");
}


// generate functions for each log level
mixin FunctionsFor!("void log$(string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) { log!(LogLevel.%, file, line, T, S)(fmt, args); }", EnumMembers!LogLevel);
