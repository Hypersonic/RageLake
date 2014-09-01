import std.string;
import entity : Entity;
import world : World;
import util : KeyState, KeyType;

class Player : Entity {
    this(World world) {
        super(world);
        cell.glyph = '@';
    }

    override void update(KeyType type, World world) {
        switch (type) {
        case KeyType.MOVE_LEFT:
            this.position.x -= 1;
            stamina -= 10;
            break;
        case KeyType.MOVE_RIGHT:
            this.position.x += 1;
            stamina -= 10;
            break;
        case KeyType.MOVE_UP:
            this.position.y -= 1;
            stamina -= 10;
            break;
        case KeyType.MOVE_DOWN:
            this.position.y += 1;
            stamina -= 10;
            break;
        default:
            break;
        }
        this.world.game.display.drawDebugMessage(format("Stamina: %d", stamina));
        super.update(type, world);
    }
}
