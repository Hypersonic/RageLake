import entity;
import item;
import action;

// Something that can be equipped. Various methods will be called when the equipee experiences certain events
class Equipment : Item {
    int maxDurability;
    int durability;

    void onAttack(ref Entity equipee, AttackAction attack) {}
    void onHit(ref Entity equipee, AttackAction attack) {}

    override bool canEquip() {
        return true;
    }
}
