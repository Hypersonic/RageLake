import std.stdio;
import game : Game;
import logger;

void main() {
    FileLogger l = new FileLogger();
    Game game = new Game();
    game.run();
}
