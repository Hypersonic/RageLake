module items.testitems;

import std.math;

import entity;
import item;
import equipment;
import action;

class TestSword : Equipment {
    mixin registerItem;
    this() {
        name = "Test Sword";
        shortDescription = "A Test Sword";
        longDescription = "This sword is a test. Go figure.";
    }

    override void onAttack(ref Entity equipee, AttackAction attack) {
        double multiplier = 3;
        attack.damage = cast(int) ceil(multiplier * attack.damage);
    }
}

class TestSpear: Equipment {
    mixin registerItem;
    this() {
        name = "Test Spear";
        shortDescription = "A Test Spear";
        longDescription = "This spear is a test. Go figure.";
    }
}
