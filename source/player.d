import entity : Entity;
import world : World;
import util : KeyState;
import config : Config;

class Player : Entity {
    this(World world) {
        super(world);
        cell.glyph = '@';
    }

    override void update(KeyState keyState, World world) {
        if (keyState.keyCode == Config.MOVE_LEFT) {
            this.position.x -= 1;
        }
        if (keyState.keyCode == Config.MOVE_RIGHT) {
            this.position.x += 1;
        }
        if (keyState.keyCode == Config.MOVE_UP) {
            this.position.y -= 1;
        }
        if (keyState.keyCode == Config.MOVE_DOWN) {
            this.position.y += 1;
        }
    }
}
