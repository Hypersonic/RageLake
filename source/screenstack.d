import display;

class ScreenStack {
    Screen[] stack;
    this() {}

    Screen pop() {
        Screen s = stack[$];
        stack = stack[0 .. $-1];
        return s;
    }

    ScreenStack push(ref Screen screen) {
        stack ~= screen;
        return this; // Return this so we can chain calls
    }

    void render(Display d) {
        void renderStack(Screen[] stack) {
            if (stack.length > 0) {
                if (stack[$].isTransparent) {
                    renderStack(stack[0 .. $-1]);
                }
                stack[$].render(d);
            }
        }

        renderStack(stack);
    }
}

class Screen {
    bool isTransparent; // Can things render behind this?
    bool inputFallthrough; // Should input go to the Screen under this?
    void render(Display display) {}
}
