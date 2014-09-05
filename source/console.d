import std.string;
import game;
import util : Event, EventType, DataType, KeyType, KeyState;
import display;
import deimos.ncurses.ncurses;

class Console {
    Game game;
    string input = "";
    string[] log;
    int height = 10;

    this(Game game) {
        this.game = game;
        input = "";
        game.display.connect(&this.render);
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

    void submit(string cmd) {
        log ~= cmd;
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
