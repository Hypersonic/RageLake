import std.stdio;
import std.string;

enum LogLevel {
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
    final bool acceptsLevel(LogLevel level) nothrow pure @safe { return level >= this.minLevel; }
    abstract void log(ref LogLine line) {}
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
    auto logmsg = format(fmt, args);
    foreach (logger; loggers) {
        auto line = LogLine(file, line, logmsg);
        logger.log(line);
    }
}

// functions for each log level
void logTrace(string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) { log!(LogLevel.trace, file, line, T, S)(fmt, args); }
void logDebug(string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) { log!(LogLevel.debug_, file, line, T, S)(fmt, args); }
void logDiagnostic(string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) { log!(LogLevel.diagnostic, file, line, T, S)(fmt, args); }
void logInfo(string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) { log!(LogLevel.info, file, line, T, S)(fmt, args); }
void logWarn(string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) { log!(LogLevel.warn, file, line, T, S)(fmt, args); }
void logError(string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) { log!(LogLevel.error, file, line, T, S)(fmt, args); }
void logCritical(string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) { log!(LogLevel.critical, file, line, T, S)(fmt, args); }
void logFatal(string file = __FILE__, int line = __LINE__, T, S...) (T fmt, lazy S args) { log!(LogLevel.fatal, file, line, T, S)(fmt, args); }
