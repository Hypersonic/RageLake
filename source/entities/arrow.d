module entities.arrow;

import entity;
import util;
import action;

class Arrow : Entity {
    int vx;
    int vy;

    this(World w, int vx, int vy) {
        super(w);
        normalColor = Color.ENEMY;
        this.vx = vx;
        this.vy = vy;
        this.staminaRechargeRate = 10;
        if (this.vx > 0) {
            cell.glyph = '>';
        } else if (this.vx < 0) {
            cell.glyph = '<';
        } else if (this.vy > 0) {
            cell.glyph = 'v';
        } else {
            cell.glyph = '^';
        }
    }
    
    override Action update(World world) {
        this.desiredAction = new MovementAction(this, vx, vy);
        super.update(world);
        return this.desiredAction;
    }
}
