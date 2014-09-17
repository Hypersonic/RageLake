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

}

void log(S...) (S args) {
    string logmsg = "";
    foreach (e; args) {
        logmsg ~= format("%s ", e);
    }
    Logger.getInstance().log(logmsg);
}
