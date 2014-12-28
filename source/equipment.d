import entity;
import item;
import action;

enum EquipRegion {
    HEAD,
    TORSO,
    LEFT_ARM,
    RIGHT_ARM,
    LEFT_LEG,
    RIGHT_LEG,
}

// Something that can be equipped. Various methods will be called when the equipee experiences certain events
class Equipment : Item {
    int maxDurability;
    int durability;
    EquipRegion[] regions;

    void onAttack(ref Entity equipee, AttackAction attack) {}
    void onDefend(ref Entity equipee, AttackAction attack) {}

}
