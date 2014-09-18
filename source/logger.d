import std.stdio;
import std.datetime;
import std.file;
import std.path;
import std.string;

class Logger {
    static Logger instance;
    string[] messages;
    File logFile;

    this() {
        auto path = relativePath("logs");
        if (!exists(path))
            mkdir(path);
        // Pick the name based on the current time
        auto time = Clock.currTime;
        auto filename = path ~ '/' ~ time.toISOString() ~ ".log";
        logFile = File(filename, "w");
    }

    // TODO: Replace this with the really awesome thread-lock safe singleton pattern from DConf 2014
    static Logger getInstance() {
        if (!instance) {
            instance = new Logger();
        }
        return instance;
    }

    void log(string s) {
        messages ~= s;
        logFile.writeln(s); // Put the line 
    }
}

void log(S...) (S args) {
    string logmsg = "";
    foreach (e; args) {
        logmsg ~= format("%s ", e);
    }
    Logger.getInstance().log(logmsg);
}
