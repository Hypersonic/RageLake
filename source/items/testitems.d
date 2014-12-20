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
        maxDurability = 10;
        durability = 10;
        regions = [EquipRegion.RIGHT_ARM];
    }

    override void onAttack(ref Entity equipee, AttackAction attack) {
        double multiplier = 3;
        if (durability > 0) {
            attack.damage = cast(int) ceil(multiplier * attack.damage);
            durability--;
        }
    }
}

class TestSpear: Equipment {
    mixin registerItem;
    this() {
        name = "Test Spear";
        shortDescription = "A Test Spear";
        longDescription = "This spear is a test. Go figure.";
        maxDurability = 10;
        durability = 10;
        regions = [EquipRegion.RIGHT_ARM, EquipRegion.LEFT_ARM];
    }

    override void onAttack(ref Entity equipee, AttackAction attack) {
        double multiplier = 3;
        if (durability > 0) {
            attack.damage = cast(int) ceil(multiplier * attack.damage);
            durability--;
        }
    }
}

class TestItem : Item {
    mixin registerItem;
    this() {
        name = "Test Item";
        shortDescription = "A Test Item";
        longDescription = "This item is a test. Wow.";
    }
}
