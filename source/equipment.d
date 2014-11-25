import entity;
import item;

// Something that can be equipped. Various methods will be called when the equipee experiences certain events
class Equipment : Item {
    void onAttack(ref Entity equipee) {}
    void onHit(ref Entity equipee) {}
}
