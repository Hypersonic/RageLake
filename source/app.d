import std.stdio;
import game : Game;
import screenstack;
import logger;

static ScreenStack screens;

void main() {
    FileLogger l = new FileLogger();
    screens = new ScreenStack();
    Game game = new Game();
    screens.push(game);
    game.console.registerFunction("screenstack", delegate(string[] s) {
            import std.string;
                game.console.logmsg(format("%s", screens.stack));
            }, "Print all the screens currently existing");
    while (!screens.empty) {
        game.tick();
        screens.render(game.display);
    }
}
