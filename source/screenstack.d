import display;
import event;

class ScreenStack {
    Screen[] stack;
    this() {}

    Screen pop() {
        Screen s = stack[$-1];
        stack = stack[0 .. $-1];
        return s;
    }

    Screen peek() {
        Screen s = stack[$-1];
        return s;
    }

    ScreenStack push(Screen screen) {
        stack ~= screen;
        return this; // Return this so we can chain calls
    }

    @property ulong size() {
        return stack.length;
    }

    @property bool empty() {
        return this.size == 0;
    }

    void takeInput() {
        import deimos.ncurses.ncurses;
        // Gather the inputted characters
        char[] states;
        KeyPress[] emitted;
        int code;
        KeyPress current;
        while ((code = getch()) != ERR){
            states ~= code;
            if (code == 27) { // Beginning of escape sequence
                current.esc_seq = true;
            } 
            // TODO: If we're in an escape sequence, handle the 2-wide escape code
            current.key = cast(char) code;
            emitted ~= current;
            current = KeyPress();
        }

        void inputStack(Screen[] stack, KeyPress kp) {
            if (stack.length > 0) {
                if (stack[$-1].inputFallthrough) {
                    inputStack(stack[0 .. $-1], kp);
                }
                stack[$-1].takeInput(kp);
            }
        }
        
        // Send the inputs to the things on the stack taking input
        foreach (kp; emitted) {
            inputStack(stack, kp);
        }


    }

    void render(Display d) {
        void renderStack(Screen[] stack) {
            if (stack.length > 0) {
                if (stack[$-1].isTransparent) {
                    renderStack(stack[0 .. $-1]);
                }
                stack[$-1].render(d);
            }
        }
        d.clear();
        renderStack(stack);
        d.update();
    }

}

class Screen {
    bool isTransparent = false; // Can things render behind this?
    bool inputFallthrough = false; // Should input go to the Screen under this?
    void takeInput(KeyPress key) {}; // Gets run once for each input this window recieves
    void render(Display display) {};
}

