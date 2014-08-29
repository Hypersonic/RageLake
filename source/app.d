import std.stdio;
import display;

void main()
{
    Display d;
    d = new Display(80, 40);
    bool running = true;
    while (running) {
        d.render();
    }
}
