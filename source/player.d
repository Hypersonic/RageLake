import entity : Entity;
import world : World;
import util : KeyState;
import config : Config, KeyType;

class Player : Entity {
    this(World world) {
        super(world);
        cell.glyph = '@';
    }

    override void update(KeyState keyState, World world) {

        auto type = Config.getKeyType(keyState);
        switch (type) {
        case KeyType.MOVE_LEFT:
            this.position.x -= 1;
            break;
        case KeyType.MOVE_RIGHT:
            this.position.x += 1;
            break;
        case KeyType.MOVE_UP:
            this.position.y -= 1;
            break;
        case KeyType.MOVE_DOWN:
            this.position.y += 1;
            break;
        default:
            break;
        }
    }
}
