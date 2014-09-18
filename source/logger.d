import std.stdio;
import std.datetime;
import std.file;
import std.path;
import std.string;

class Logger {
    static Logger instance;
    string[] messages;

    this() {}

    // TODO: Replace this with the really awesome thread-lock safe singleton pattern from DConf 2014
    static Logger getInstance() {
        if (!instance) {
            instance = new Logger();
        }
        return instance;
    }

    void log(string s) {
        messages ~= s;
    }

    void saveToFile() {
        auto path = relativePath("logs");
        if (!exists(path))
            mkdir(path);
        auto filename = path ~ '/' ~ Clock.currTime.toISOString() ~ ".log";
        auto f = File(filename, "w");
        foreach (line; messages) {
            f.writeln(line);
        }
        // f is closed as we exit scope
    }
}

void log(S...) (S args) {
    string logmsg = "";
    foreach (e; args) {
        logmsg ~= format("%s ", e);
    }
    Logger.getInstance().log(logmsg);
}
