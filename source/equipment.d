import entity;

// Something that can be equipped. Various methods will be called when the equipee experiences certain events
class Equipment {
    void onAttack(ref Entity equipee) {}
    void onHit(ref Entity equipee) {}
}
