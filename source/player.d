import std.string;
import entity : Entity;
import world : World;
import util : KeyType, EventType;

class Player : Entity {
    this(World world) {
        super(world);
        cell.glyph = '@';
    }

    override void watch(EventType event, KeyType key) {
        if (stamina >= 10) {
        if (event == EventType.KEY_PRESS) {
        switch (key) {
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
        }
        }
    }

    override void update(World world) {
        this.world.game.display.drawDebugMessage(format("Stamina: %d", stamina));
        super.update(world);
    }
}
