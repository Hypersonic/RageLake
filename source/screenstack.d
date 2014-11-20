import display;

class ScreenStack {
    Screen[] stack;
    this() {}

    Screen pop() {
        Screen s = stack[$];
        stack = stack[0 .. $-1];
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

    void render(Display d) {
        void renderStack(Screen[] stack) {
            if (stack.length > 0) {
                if (stack[$-1].isTransparent) {
                    renderStack(stack[0 .. $-1]);
                }
                stack[$-1].render(d);
            }
        }
        renderStack(stack);
    }
}

class Screen {
    bool isTransparent = true; // Can things render behind this?
    bool inputFallthrough = true; // Should input go to the Screen under this?
    void render(Display display) {};
}
