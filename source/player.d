import std.string;
import entity : Entity;
import world : World;
import action : Action, MovementAction;
import util : KeyType, EventType, Event;

class Player : Entity {
    this(World world) {
        super(world);
        cell.glyph = '@';
    }

    override void watch(Event event) {
        if (event.type == EventType.KEY_PRESS) {
        switch (event.data.key) {
        case KeyType.MOVE_LEFT:
            desiredAction = new MovementAction(this, -1, 0);
            break;
        case KeyType.MOVE_RIGHT:
            desiredAction = new MovementAction(this, 1, 0);
            break;
        case KeyType.MOVE_UP:
            desiredAction = new MovementAction(this, 0, -1);
            break;
        case KeyType.MOVE_DOWN:
            desiredAction = new MovementAction(this, 0, 1);
            break;
        default:
            break;
        }
        }
    }

    override void update(World world) {
        this.world.game.display.drawDebugMessage(format("Stamina: %d", stamina));
        super.update(world);
    }
}
